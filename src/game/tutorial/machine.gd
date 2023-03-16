extends PanelContainer

var ballScene = preload("res://game/ball.tscn")
var ballStartPosition: Vector2 = Vector2(485, 730)
var ballPlungeVelocity: Vector2 = Vector2(0, -1500)

func _ready():
	get_tree().paused = true

func play():
	get_tree().paused = false
	plunge()
	$FlipperLeft.isRunning = true
	$FlipperRight.isRunning = true

func stop():
	$FlipperLeft.isRunning = false
	$FlipperRight.isRunning = false

func plunge():
	var ball: RigidBody2D = ballScene.instantiate()
	ball.position = ballStartPosition
	ball.linear_velocity = ballPlungeVelocity
	add_child(ball)


func _on_drain_gutter_area_2d_body_entered(body):
	if body.is_in_group("isBall"):
		body.queue_free()
		var balls = get_tree().get_nodes_in_group("isBall")
		var size = balls.size()
		if size == 0 or (size == 1 and balls[0] == body):
			stop()
