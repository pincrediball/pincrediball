extends RigidBody2D

const SOUNDS_FOR_WALLS_NORMAL: Array[Resource] = [
	preload("res://sound/wall-normal-001.wav"),
]

const SOUNDS_FOR_WALLS_SOFT: Array[Resource] = [
	preload("res://sound/wall-soft-001.wav"),
]

const SOUNDS_FOR_WALLS_SOFTEST: Array[Resource] = [
	preload("res://sound/wall-softest-001.wav"),
]


func _on_body_entered(body):
	if body.is_in_group("isWall"):
		var speed = self.linear_velocity.length()
		if speed > 600:
			Audio.play_random_sound_with($AudioStreamPlayer, SOUNDS_FOR_WALLS_NORMAL)
		elif speed > 300:
			Audio.play_random_sound_with($AudioStreamPlayer, SOUNDS_FOR_WALLS_SOFT)
		elif speed > 50:
			Audio.play_random_sound_with($AudioStreamPlayer, SOUNDS_FOR_WALLS_SOFTEST)
	if body.has_method(&"on_ball_entered"):
		body.on_ball_entered(self)


func _on_body_exited(body):
	# TODO: This code is quite fragile and needs a better solution...
	if body.has_method(&"on_ball_exit"):
		body.on_ball_exit(self)
	elif body.get_parent().has_method(&"on_ball_exit"):
		body.get_parent().on_ball_exit(self)
