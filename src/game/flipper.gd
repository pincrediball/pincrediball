extends Node2D

const sounds = [
	preload("res://sound/flipper-001.wav"),
	preload("res://sound/flipper-002.wav"),
	preload("res://sound/flipper-003.wav"),
	preload("res://sound/flipper-004.wav"),
	preload("res://sound/flipper-005.wav"),
]

enum FlipperState { RESTING, GOING_UP, GOING_DOWN }

const MAX_ROTATION := -85.0
const REST_ANGLE := 35.0
const TIME_TO_MOVE_UP := 0.06
const TIME_TO_MOVE_DOWN := 0.3

var state := FlipperState.RESTING
var time_moving := 0.0
var is_running := false


func reset(interval: float):
	$Timer.wait_time = interval
	$Timer.start()
	is_running = true
	state = FlipperState.RESTING
	time_moving = 0.0
	$CharacterBody2D.rotation_degrees = REST_ANGLE


func stop():
	$Timer.stop()
	is_running = false


func _physics_process(delta):
	if !is_running or state == FlipperState.RESTING:
		return
	
	time_moving += delta
	
	if state == FlipperState.GOING_UP:
		$CharacterBody2D.rotation_degrees = MAX_ROTATION * (time_moving / TIME_TO_MOVE_UP) + REST_ANGLE
		if time_moving > TIME_TO_MOVE_UP:
			state = FlipperState.GOING_DOWN
			time_moving = 0.0

	else:
		$CharacterBody2D.rotation_degrees = MAX_ROTATION * (1 - (time_moving / TIME_TO_MOVE_DOWN)) + REST_ANGLE
		if time_moving > TIME_TO_MOVE_DOWN:
			state = FlipperState.RESTING
			time_moving = 0.0


func _on_timer_timeout():
	assert(state == FlipperState.RESTING, "Flipper should fire but was not yet resting!")
	state = FlipperState.GOING_UP
	$AudioStreamPlayer.stream = sounds[randi() % len(sounds)]
	$AudioStreamPlayer.play()
