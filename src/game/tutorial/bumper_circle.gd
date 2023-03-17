extends StaticBody2D

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
