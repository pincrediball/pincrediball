extends StaticBody2D

signal move_by_player_ended(node: Node2D)

const BASE_SCORE = 25
const sounds = [
	preload("res://sound/bumper-001.wav"),
	preload("res://sound/bumper-002.wav"),
	preload("res://sound/bumper-003.wav"),
	preload("res://sound/bumper-004.wav"),
]

func on_ball_exit(ball: RigidBody2D):
	$AudioStreamPlayer.stream = sounds[randi() % len(sounds)]
	$AudioStreamPlayer.play()
	var direction = (ball.position - self.position).normalized()
	var impulse = direction * 1000
	ball.apply_impulse(impulse)
	Scoring.add_score(BASE_SCORE)

var selected := false
var previous_position: Vector2

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
