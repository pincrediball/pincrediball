extends RigidBody2D

func _on_body_entered(body):
	if body.has_method(&"on_ball_entered"):
		body.on_ball_entered(self)

func _on_body_exited(body):
	if body.has_method(&"on_ball_exit"):
		body.on_ball_exit(self)
