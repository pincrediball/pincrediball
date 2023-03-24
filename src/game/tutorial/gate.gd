extends PlayerControlledComponent

const BASE_SCORE = 100
const SOUNDS_FOR_ROLLOVER: Array[Resource] = [
	preload("res://sound/rollover-001.wav"),
	preload("res://sound/rollover-002.wav"),
	preload("res://sound/rollover-003.wav"),
	preload("res://sound/rollover-004.wav"),
]

var is_activated: bool = false:
	get:
		return is_activated
	set(value):
		if value != is_activated:
			%Sprite2DRollOver.modulate = Color(1, 1, 1, 1) if value else Color(0.16, 0.16, 0.16, 1)
			is_activated = value
			if value:
				play_random_sound(SOUNDS_FOR_ROLLOVER)


func _ready():
	super._ready()
	sounds_default = [
		preload("res://sound/wall-001.wav"),
		preload("res://sound/wall-002.wav"),
		preload("res://sound/wall-003.wav"),
		preload("res://sound/wall-004.wav"),
	]


func _on_roll_over_area_2d_body_exited(body):
	if not is_activated and body.is_in_group("isBall") and body.linear_velocity.y > 0:
		is_activated = true
		Scoring.add_score(BASE_SCORE)


func resetPinballComponent():
	is_activated = false


func _unhandled_input(event): handle_unhandled_input(event)
func _on_component_area_2d_mouse_entered(): is_mouse_over_body = true
func _on_component_area_2d_mouse_exited(): is_mouse_over_body = false
