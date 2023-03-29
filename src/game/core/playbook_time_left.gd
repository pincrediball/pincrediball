extends Node2D

@export var run_time_left := 0.0:
	get:
		return run_time_left
	set(value):
		run_time_left = value
		Scoring.update_time_left_to(run_time_left)


func _physics_process(delta):
	run_time_left -= delta
