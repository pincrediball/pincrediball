extends Node2D

const sounds = [
	preload("res://sound/flipper-001.wav"),
	preload("res://sound/flipper-002.wav"),
	preload("res://sound/flipper-003.wav"),
	preload("res://sound/flipper-004.wav"),
	preload("res://sound/flipper-005.wav"),
]

# Settings:
var max_rotation: float = -85
var rest_angle: float = 35
var up_time: float = 0.06
const down_time: float = 0.3
var isRunning: bool = false

# State:
enum FlipperState { Resting, GoingUp, GoingDown }
var state: FlipperState = FlipperState.Resting
var time_moving: float = 0.0

func reset(interval: float):
	$Timer.wait_time = interval
	$Timer.start()
	isRunning = true
	state = FlipperState.Resting
	time_moving = 0.0
	$CharacterBody2D.rotation_degrees = rest_angle

func stop():
	$Timer.stop()
	isRunning = false

func _physics_process(delta):
	if !isRunning or state == FlipperState.Resting:
		return
	
	time_moving += delta
	
	if state == FlipperState.GoingUp:
		$CharacterBody2D.rotation_degrees = max_rotation * (time_moving / up_time) + rest_angle
		if time_moving > up_time:
			state = FlipperState.GoingDown
			time_moving = 0.0

	else:
		$CharacterBody2D.rotation_degrees = max_rotation * (1 - (time_moving / down_time)) + rest_angle
		if time_moving > down_time:
			state = FlipperState.Resting
			time_moving = 0.0

func _on_timer_timeout():
	assert(state == FlipperState.Resting, "Flipper should fire but was not yet resting!")
	state = FlipperState.GoingUp
	$AudioStreamPlayer.stream = sounds[randi() % len(sounds)]
	$AudioStreamPlayer.play()
