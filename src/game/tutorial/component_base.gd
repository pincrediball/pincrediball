class_name PlayerControlledComponent extends Node2D

signal move_by_player_ended(node: Node2D)

var sounds_default = []
var is_mouse_over_body := false
var selected := false
var lerp_offset := Vector2.ZERO
var previous_position: Vector2
var audio_stream_player = AudioStreamPlayer.new()

func _ready():
	audio_stream_player.bus = Audio.bus_name_pinball_sfx
	add_child(audio_stream_player)

func on_ball_exit(_ball: RigidBody2D):
	play_random_sound()

func play_random_sound(sounds = null):
	if sounds == null:
		sounds = sounds_default
	if sounds.size() > 0:
		audio_stream_player.stream = sounds[randi() % len(sounds)]
		audio_stream_player.play()

func end_move():
	if selected:
		selected = false
		move_by_player_ended.emit(self)

func _physics_process(delta):
	if selected:
		var target = get_global_mouse_position() - lerp_offset
		global_position = lerp(global_position, target, delta * 20)

func handle_unhandled_input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if selected and not event.is_pressed():
			selected = false
			move_by_player_ended.emit(self)
		elif is_mouse_over_body and not selected and event.is_pressed():
			selected = true
			previous_position = global_position
			lerp_offset = get_local_mouse_position()
			get_viewport().set_input_as_handled()

func move_to_last_known_position():
	global_position = previous_position
