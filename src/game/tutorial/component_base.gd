class_name PlayerControlledStaticBody2D extends StaticBody2D

signal move_by_player_ended(node: Node2D)

var sounds_default = []
var selected := false
var previous_position: Vector2
var audio_stream_player = AudioStreamPlayer.new()

func _ready():
	self.input_event.connect(_on_input_event)
	audio_stream_player.bus = Audio.bus_name_pinball_sfx
	add_child(audio_stream_player)

func on_ball_exit(ball: RigidBody2D):
	play_random_sound()

func play_random_sound(sounds = null):
	if sounds == null:
		sounds = sounds_default
	if sounds.size() > 0:
		audio_stream_player.stream = sounds[randi() % len(sounds)]
		audio_stream_player.play()

func _physics_process(delta):
	if selected:
		global_position = lerp(global_position, get_global_mouse_position(), delta * 25)

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if selected and not event.is_pressed():
			selected = false
			move_by_player_ended.emit(self)
		if not selected and event.is_pressed():
			selected = true
			previous_position = global_position

func move_to_last_known_position():
	global_position = previous_position
