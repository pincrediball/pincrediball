extends StaticBody2D

const BASE_SCORE = 0

func on_ball_exit(ball: RigidBody2D):
	if $SlingArea2D.overlaps_body(ball):
		var direction = $SlingArea2D/CollisionShape2D.global_rotation
		var baseForce = Vector2(1, 0).rotated(direction)
		var impulse = baseForce * 1000
		ball.apply_impulse(impulse)
		Scoring.add_score(BASE_SCORE)
