extends StaticBody2D

func on_ball_entered(ball: RigidBody2D):
	var direction = $SlingArea2D/CollisionShape2D.global_rotation
	var baseForce = Vector2(1, 0).rotated(direction)
	var impulse = baseForce * 1000
	ball.apply_impulse(impulse)
	Scoring.add_score(25)
