extends Node2D

const soundsPlunge = [
	preload("res://sound/plunge-001.wav"),
	preload("res://sound/plunge-002.wav"),
	preload("res://sound/plunge-003.wav"),
]

const soundsDrain = [
	preload("res://sound/drain-001.wav"),
	preload("res://sound/drain-002.wav"),
]

var ballScene = preload("res://game/ball.tscn")
var ballStartPosition: Vector2 = Vector2(485, 730)
var ballPlungeVelocity: Vector2 = Vector2(0, -1500)

func _ready():
	stop()

func play(levelPlaybook):
	Music.suppress()
	get_tree().paused = false
	get_tree().call_group("isResettablePinballComponent", "resetPinballComponent")
	$FlipperLeft.reset(levelPlaybook.flipper_left_interval)
	$FlipperRight.reset(levelPlaybook.flipper_right_interval)
	get_tree().create_timer(levelPlaybook.plunge_delay).connect("timeout", plunge)

func stop():
	get_tree().paused = true
	$FlipperLeft.stop()
	$FlipperRight.stop()
	Music.unsuppress()

func plunge():
	$AudioStreamPlayer.stream = soundsPlunge[randi() % len(soundsPlunge)]
	$AudioStreamPlayer.play()
	var ball: RigidBody2D = ballScene.instantiate()
	ball.position = ballStartPosition
	ball.linear_velocity = ballPlungeVelocity
	add_child(ball)

func _on_drain_gutter_area_2d_body_entered(body):
	if body.is_in_group("isBall"):
		$AudioStreamPlayer.stream = soundsDrain[randi() % len(soundsDrain)]
		$AudioStreamPlayer.play()
		body.queue_free()
		var balls = get_tree().get_nodes_in_group("isBall")
		var size = balls.size()
		if size == 0 or (size == 1 and balls[0] == body):
			stop()

func _on_plunger_area_2d_body_exited(body):
	if body.is_in_group("isBall"):
		var ball = body as RigidBody2D
		ball.set_collision_mask_value(2, true)
