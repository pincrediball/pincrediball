extends Node2D

const SOUNDS: Array[Resource] = [
	preload("res://sound/flipper-001.wav"),
	preload("res://sound/flipper-002.wav"),
]

enum FlipperState { RESTING, GOING_UP, GOING_DOWN }

const MAX_ROTATION := -85.0
const REST_ANGLE := 35.0
const TIME_TO_MOVE_UP := 0.06
const TIME_TO_MOVE_DOWN := 0.3

@export var sound_index = 0

var _state := FlipperState.RESTING
var _time_moving := 0.0
var _is_running := false


func _physics_process(delta):
	if !_is_running or _state == FlipperState.RESTING:
		return
	
	_time_moving += delta
	
	if _state == FlipperState.GOING_UP:
		$CharacterBody2D.rotation_degrees = MAX_ROTATION * (_time_moving / TIME_TO_MOVE_UP) + REST_ANGLE
		if _time_moving > TIME_TO_MOVE_UP:
			_state = FlipperState.GOING_DOWN
			_time_moving = 0.0

	else:
		$CharacterBody2D.rotation_degrees = MAX_ROTATION * (1 - (_time_moving / TIME_TO_MOVE_DOWN)) + REST_ANGLE
		if _time_moving > TIME_TO_MOVE_DOWN:
			_state = FlipperState.RESTING
			_time_moving = 0.0


func reset(interval: float):
	$Timer.wait_time = interval
	$Timer.start()
	_is_running = true
	_state = FlipperState.RESTING
	_time_moving = 0.0
	$CharacterBody2D.rotation_degrees = REST_ANGLE


func stop():
	$Timer.stop()
	_is_running = false


func _on_timer_timeout():
	assert(_state == FlipperState.RESTING, "Flipper should fire but was not yet resting!")
	_state = FlipperState.GOING_UP
	$AudioStreamPlayer.stream = SOUNDS[sound_index]
	$AudioStreamPlayer.play()
