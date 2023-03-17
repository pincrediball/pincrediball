extends StaticBody2D

const BASE_SCORE = 10
const sounds = [
	preload("res://sound/bumper-101.wav"),
	preload("res://sound/bumper-102.wav"),
	preload("res://sound/bumper-103.wav"),
]

func on_ball_exit(ball: RigidBody2D):
	if $SlingArea2D.overlaps_body(ball):
		$AudioStreamPlayer.stream = sounds[randi() % len(sounds)]
		$AudioStreamPlayer.play()
		var direction = $SlingArea2D/CollisionShape2D.global_rotation
		var baseForce = Vector2(1, 0).rotated(direction)
		var impulse = baseForce * 1000
		ball.apply_impulse(impulse)
		Scoring.add_score(BASE_SCORE)
