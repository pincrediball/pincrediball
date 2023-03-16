extends Node2D

@export
var max_rotation = -85

var rest_angle = 35

@export
var up_time = 0.06

@export
var isRunning = false

var is_going_up = true
var time_moving = 0.0
const down_time = 0.3

func _physics_process(delta):
	if !isRunning:
		return
	
	time_moving += delta
	
	if is_going_up:
		$CharacterBody2D.rotation_degrees = max_rotation * (time_moving / up_time) + rest_angle
		if time_moving > up_time:
			is_going_up = false
			time_moving = 0.0

	else:
		$CharacterBody2D.rotation_degrees = max_rotation * (1 - (time_moving / down_time)) + rest_angle
		if time_moving > down_time:
			is_going_up = true
			time_moving = 0.0
