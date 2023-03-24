extends PlayerControlledComponent

const BASE_SCORE = 10


func _ready():
	super._ready()
	sounds_default = [
		preload("res://sound/bumper-101.wav"),
		preload("res://sound/bumper-102.wav"),
		preload("res://sound/bumper-103.wav"),
	]


func on_ball_exit(ball: RigidBody2D):
	if %SlingArea2D.overlaps_body(ball):
		play_random_sound()
		var direction = %SlingArea2D/CollisionShape2D.global_rotation
		var baseForce = Vector2(1, 0).rotated(direction)
		var impulse = baseForce * 1000
		ball.apply_impulse(impulse)
		Scoring.add_score(BASE_SCORE)


func _unhandled_input(event): handle_unhandled_input(event)
func _on_component_area_2d_mouse_entered(): is_mouse_over_body = true
func _on_component_area_2d_mouse_exited(): is_mouse_over_body = false
