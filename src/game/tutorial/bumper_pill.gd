extends PlayerControlledComponent

const BASE_SCORE = 10

func _ready():
	super._ready()
	$ComponentArea2D.input_event.connect(_on_input_event_for_drag_hitbox)
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
