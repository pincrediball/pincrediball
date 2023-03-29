class_name PlayerControlledComponent extends Node2D

signal move_by_player_ended(node: Node2D)

const ROTATION_STEP_DEGREES = 9 # multiples now include 45, 180, etc.
const MOVE_STEP = 20

var level := 0

var _sounds_default: Array[Resource] = []
var _is_mouse_over_body := false
var _selected := false
var _rotating := false
var _lerp_offset := Vector2.ZERO
var _previous_position: Vector2
var _previous_rotation: float
var _audio_stream_player := AudioStreamPlayer.new()


func _ready():
	_audio_stream_player.bus = Audio.BUS_NAME_PINBALL_SFX
	add_child(_audio_stream_player)
	GameStore.level_changed.connect(_on_level_changed)


func _physics_process(delta):
	if _selected:
		# TODO: The lerp_offset doesn't work anymore when rotated
		var target = get_global_mouse_position() - _lerp_offset
		global_position = lerp(global_position, target, delta * MOVE_STEP)
	elif _rotating:
		# TODO: Fix rotating initially and weirdly
		var origin = global_position
		var direction = get_global_mouse_position() - origin
		var angle = rad_to_deg(global_position.angle_to(direction))
		rotation_degrees = snapped(angle, ROTATION_STEP_DEGREES)


func on_ball_exit(_ball: RigidBody2D):
	_play_random_sound()


func end_move():
	if _selected:
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
			_lerp_offset = get_local_mouse_position()
			if not get_tree().paused:
				Scoring.set_enabled(false)
			get_viewport().set_input_as_handled()
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		if _rotating and not event.is_pressed():
			_rotating = false
			move_by_player_ended.emit(self)
		elif _is_mouse_over_body and not _rotating and event.is_pressed():
			_rotating = true
			_previous_position = global_position
			_previous_rotation = rotation
			_lerp_offset = get_local_mouse_position()
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
