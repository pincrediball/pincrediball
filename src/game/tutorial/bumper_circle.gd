extends PlayerControlledComponent

const BASE_SCORE = 25


func _ready():
	super._ready()
	_sounds_default = [
		preload("res://sound/bumper-001.wav"),
		preload("res://sound/bumper-002.wav"),
		preload("res://sound/bumper-003.wav"),
		preload("res://sound/bumper-004.wav"),
	]


func _unhandled_input(event): _handle_unhandled_input(event)
func _on_component_area_2d_mouse_entered(): _is_mouse_over_body = true
func _on_component_area_2d_mouse_exited(): _is_mouse_over_body = false


func on_ball_exit(ball: RigidBody2D):
	super.on_ball_exit(ball)
	var direction := (ball.position - self.position).normalized()
	var impulse := direction * 1000
	ball.apply_impulse(impulse)
	Scoring.add_score(BASE_SCORE)


func _set_ethereal(is_ethereal: bool):
	$StaticBody2D.set_collision_layer_value(1, not is_ethereal)
	$StaticBody2D.set_collision_mask_value(1, not is_ethereal)
