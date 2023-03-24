extends StaticBody2D

const BASE_SCORE = 0
const SOUNDS: Array[Resource] = [
	preload("res://sound/sling-001.wav"),
	preload("res://sound/sling-002.wav"),
	preload("res://sound/sling-003.wav"),
]

func on_ball_exit(ball: RigidBody2D):
	if $SlingArea2D.overlaps_body(ball):
		Audio.play_random_sound_with($AudioStreamPlayer, SOUNDS)
		var direction = $SlingArea2D/CollisionShape2D.global_rotation
		var base_force = Vector2(1, -0.25).rotated(direction)
		var impulse = base_force * 1000
		ball.apply_impulse(impulse)
		Scoring.add_score(BASE_SCORE)
