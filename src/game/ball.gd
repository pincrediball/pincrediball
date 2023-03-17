extends RigidBody2D

const soundsWalls = [
	preload("res://sound/wall-001.wav"),
	preload("res://sound/wall-002.wav"),
	preload("res://sound/wall-003.wav"),
	preload("res://sound/wall-004.wav"),
	preload("res://sound/wall-005.wav"),
	preload("res://sound/wall-006.wav"),
	preload("res://sound/wall-007.wav"),
	preload("res://sound/wall-008.wav"),
]

func _on_body_entered(body):
	if body.is_in_group("isWall"):
		$AudioStreamPlayer.stream = soundsWalls[randi() % len(soundsWalls)]
		$AudioStreamPlayer.play()
		
	if body.has_method(&"on_ball_entered"):
		body.on_ball_entered(self)

func _on_body_exited(body):
	if body.has_method(&"on_ball_exit"):
		body.on_ball_exit(self)
