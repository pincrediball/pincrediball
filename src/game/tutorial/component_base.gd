class_name PlayerControlledComponent extends Node2D

signal move_by_player_ended(node: Node2D)

const ROTATION_STEP_DEGREES = 9 # multiples now include 45, 180, etc.
const MOVE_STEP = 20

var level := 0

var _sounds_default: Array[Resource] = []
var _is_mouse_over_body := false
var _selected := false
var _rotating := false
var _position_offset := Vector2.ZERO
var _rotation_offset := 0.0
var _previous_position: Vector2
var _previous_rotation: float
var _audio_stream_player := AudioStreamPlayer.new()
var _rotation_helper_line := Line2D.new()


func _ready():
	_set_up_rotation_helper_line()	
	_audio_stream_player.bus = Audio.BUS_NAME_PINBALL_SFX
	add_child(_audio_stream_player)
	GameStore.level_changed.connect(_on_level_changed)


func _physics_process(delta):
	if _selected:
		var target = get_global_mouse_position() - _position_offset
		global_position = lerp(global_position, target, delta * MOVE_STEP)
	elif _rotating:
		var direction = get_global_mouse_position() - global_position
		var angle_rads = direction.angle() - _rotation_offset
		var angle_degrees = rad_to_deg(angle_rads) # Degrees improves snapping
		rotation_degrees = snapped(angle_degrees, ROTATION_STEP_DEGREES)
		_rotation_helper_line.set_point_position(1, get_local_mouse_position())


func on_ball_exit(_ball: RigidBody2D):
	_play_random_sound()


func end_move():
	_rotation_helper_line.visible = false
	if _selected or _rotating:
		_rotating = false
		_selected = false
		move_by_player_ended.emit(self)


func move_to_last_known_position():
	global_position = _previous_position
	rotation = _previous_rotation


func _play_random_sound(sounds = null):
	if sounds == null:
		sounds = _sounds_default
	if sounds.size() > 0:
		Audio.play_random_sound_with(_audio_stream_player, sounds)


func _handle_unhandled_input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if _selected and not event.is_pressed():
			_selected = false
			move_by_player_ended.emit(self)
		elif _is_mouse_over_body and not _selected and event.is_pressed():
			_selected = true
			_previous_position = global_position
			_previous_rotation = rotation
			_position_offset = get_local_mouse_position().rotated(rotation)
			if not get_tree().paused:
				Scoring.set_enabled(false)
			get_viewport().set_input_as_handled()
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		if _rotating and not event.is_pressed():
			_rotating = false
			_rotation_helper_line.visible = false
			move_by_player_ended.emit(self)
		elif _is_mouse_over_body and not _rotating and event.is_pressed():
			_rotating = true
			_previous_position = global_position
			_previous_rotation = rotation
			_rotation_offset = (get_global_mouse_position() - global_position).angle() - rotation
			_rotation_helper_line.visible = true
			if not get_tree().paused:
				Scoring.set_enabled(false)
			get_viewport().set_input_as_handled()


func _on_level_changed(new_level: int):
	if new_level < level:
		_set_ethereal(true)
		modulate = Color(0.5, 0.5, 0.5, 0.35)
		
	else:
		_set_ethereal(false)
		modulate = Color(1.0, 1.0, 1.0, 1)


func _set_ethereal(is_ethereal: bool):
	pass # To be implemented by subclasses that know their shapes


func _set_up_rotation_helper_line():
	_rotation_helper_line.add_point(Vector2.ZERO)
	_rotation_helper_line.add_point(Vector2.ZERO)
	_rotation_helper_line.default_color = Color(0.9, 0.2, 0.1, 0.5)
	_rotation_helper_line.width = 2
	_rotation_helper_line.visible = false
	add_child(_rotation_helper_line)
