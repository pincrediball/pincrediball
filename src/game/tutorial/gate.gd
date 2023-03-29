extends PlayerControlledComponent

const BASE_SCORE = 100
const SOUNDS_FOR_ROLLOVER: Array[Resource] = [
	preload("res://sound/rollover-001.wav"),
	preload("res://sound/rollover-002.wav"),
	preload("res://sound/rollover-003.wav"),
	preload("res://sound/rollover-004.wav"),
]

var _is_activated: bool = false:
	get:
		return _is_activated
	set(value):
		if value != _is_activated:
			%Sprite2DRollOver.modulate = Color(1, 1, 1, 1) if value else Color(0.16, 0.16, 0.16, 1)
			_is_activated = value
			if value:
				# Different stream player so it can run parallel with wall hits
				Audio.play_random_sound_with($AudioStreamPlayer, SOUNDS_FOR_ROLLOVER)


func _ready():
	super._ready()
	_sounds_default = [
		preload("res://sound/wall-normal-001.wav"),
	]


func _unhandled_input(event): _handle_unhandled_input(event)
func _on_component_area_2d_mouse_entered(): _is_mouse_over_body = true
func _on_component_area_2d_mouse_exited(): _is_mouse_over_body = false


func _on_roll_over_area_2d_body_exited(body):
	if not _is_activated and body.is_in_group("isBall"):
		# The component might be rotated, so we need to adjust
		# the direction of the velocity for this to keep the
		# gate one-way.
		if body.linear_velocity.rotated(rotation).y > 0:
			_is_activated = true
			Scoring.add_score(BASE_SCORE)


func reset_pinball_component():
	_is_activated = false


func _set_ethereal(is_ethereal: bool):
	$StaticBody2D.set_collision_layer_value(1, not is_ethereal)
	$StaticBody2D.set_collision_mask_value(1, not is_ethereal)
	$RollOverArea2D.set_collision_layer_value(1, not is_ethereal)
	$RollOverArea2D.set_collision_mask_value(1, not is_ethereal)
