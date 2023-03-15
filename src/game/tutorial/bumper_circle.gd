extends StaticBody2D

const BASE_SCORE = 25

func on_ball_exit(ball: RigidBody2D):
	var direction = (ball.position - self.position).normalized()
	var impulse = direction * 1000
	ball.apply_impulse(impulse)
	Scoring.add_score(BASE_SCORE)
