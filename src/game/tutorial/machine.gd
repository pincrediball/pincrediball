extends SubViewportContainer

const soundsPlunge = [
	preload("res://sound/plunge-001.wav"),
	preload("res://sound/plunge-002.wav"),
	preload("res://sound/plunge-003.wav"),
]

const soundsDrain = [
	preload("res://sound/drain-001.wav"),
	preload("res://sound/drain-002.wav"),
]

const component_scenes = {
	"bumper_circle": preload("res://game/tutorial/bumper_circle.tscn"),
	"bumper_pill": preload("res://game/tutorial/bumper_pill.tscn"),
	"wall_corner": preload("res://game/tutorial/wall_corner.tscn"),
	"gate": preload("res://game/tutorial/gate.tscn"),
}

var ballScene = preload("res://game/ball.tscn")
var ballStartPosition: Vector2 = Vector2(485, 730)
var ballPlungeVelocity: Vector2 = Vector2(0, -1500)
var ballsToPlunge := 0

func _ready():
	%DropZonePolygon2D.visible = false
	stop()

func init_play(levelPlaybook):
	%BallPlungeTimer.start(levelPlaybook.plunge_delay)
	Audio.set_suppressed_music(true)
	for ball in get_tree().get_nodes_in_group("isBall"):
		ball.queue_free()
	get_tree().paused = false
	get_tree().call_group("isResettablePinballComponent", "resetPinballComponent")
	%FlipperLeft.reset(levelPlaybook.flipper_left_interval)
	%FlipperRight.reset(levelPlaybook.flipper_right_interval)

func play(levelPlaybook):
	ballsToPlunge = 1
	init_play(levelPlaybook)

func stress_test(levelPlaybook):
	ballsToPlunge = 10
	init_play(levelPlaybook)

func stop():
	get_tree().paused = true
	%FlipperLeft.stop()
	%FlipperRight.stop()
	Audio.set_suppressed_music(false)

func plunge():
	if ballsToPlunge > 0:
		ballsToPlunge -= 1
		$AudioStreamPlayer.stream = soundsPlunge[randi() % len(soundsPlunge)]
		$AudioStreamPlayer.play()
		var ball: RigidBody2D = ballScene.instantiate()
		ball.position = ballStartPosition
		ball.linear_velocity = ballPlungeVelocity
		%MachineNode2D.add_child(ball)

func set_drop_zone_glow_enabled(is_enabled: bool):
	%DropZonePolygon2D.visible = is_enabled
	if is_enabled:
		%DropZonePolygon2D/AnimationPlayer.seek(0)
		%DropZonePolygon2D/AnimationPlayer.play("drop_zone_glow")

func is_in_allowed_area(at_position: Vector2):
	return Geometry2D.is_point_in_polygon(at_position, %DropZonePolygon2D.polygon)

func _on_ball_plunge_timer_timeout():
	plunge()

func _on_drain_gutter_area_2d_body_entered(body):
	if body.is_in_group("isBall"):
		$AudioStreamPlayer.stream = soundsDrain[randi() % len(soundsDrain)]
		$AudioStreamPlayer.play()
		body.queue_free()
		var balls = get_tree().get_nodes_in_group("isBall")
		var nr_of_balls = balls.size()
		if nr_of_balls == 0 or (nr_of_balls == 1 and balls[0] == body):
			stop()

func _on_plunger_area_2d_body_exited(body):
	if body.is_in_group("isBall"):
		var ball = body as RigidBody2D
		ball.set_collision_mask_value(2, true)

func _can_drop_data(at_position, data):
	return data.is_toolbox_item && is_in_allowed_area(at_position)

func _drop_data(at_position, data):
	var component = component_scenes[data.component_id].instantiate() as Node2D
	component.position = at_position
	component.move_by_player_ended.connect(on_move_by_player_ended)
	%PlayerComponents.add_child(component)
	set_drop_zone_glow_enabled(false)
	GameStore.clearDragData()

func _on_mouse_entered():
	if GameStore.is_dragging:
		set_drop_zone_glow_enabled(true)

func _on_mouse_exited():
	set_drop_zone_glow_enabled(false)

func _on_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		set_drop_zone_glow_enabled(event.is_pressed())
		if not event.is_pressed():
			for child in %PlayerComponents.get_children():
				child.end_move()

func on_move_by_player_ended(node: Node2D):
	if not is_in_allowed_area(node.position):
		node.move_to_last_known_position()
