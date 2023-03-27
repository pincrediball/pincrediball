class_name PlayerControlledComponent extends Node2D

signal move_by_player_ended(node: Node2D)

var _sounds_default: Array[Resource] = []
var _is_mouse_over_body := false
var _selected := false
var _lerp_offset := Vector2.ZERO
var _previous_position: Vector2
var _audio_stream_player := AudioStreamPlayer.new()


func _ready():
	_audio_stream_player.bus = Audio.BUS_NAME_PINBALL_SFX
	add_child(_audio_stream_player)


func _physics_process(delta):
	if _selected:
		var target = get_global_mouse_position() - _lerp_offset
		global_position = lerp(global_position, target, delta * 20)


func on_ball_exit(_ball: RigidBody2D):
	_play_random_sound()


func end_move():
	if _selected:
		_selected = false
		move_by_player_ended.emit(self)


func move_to_last_known_position():
	global_position = _previous_position


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
			_lerp_offset = get_local_mouse_position()
			if not get_tree().paused:
				Scoring.set_enabled(false)
			get_viewport().set_input_as_handled()
