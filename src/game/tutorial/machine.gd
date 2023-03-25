extends SubViewportContainer

const SOUNDS_FOR_PLUNGING: Array[Resource] = [
	preload("res://sound/plunge-001.wav"),
	preload("res://sound/plunge-002.wav"),
	preload("res://sound/plunge-003.wav"),
]

const SOUNDS_FOR_DRAINING: Array[Resource] = [
	preload("res://sound/drain-001.wav"),
	preload("res://sound/drain-002.wav"),
]

const COMPONENT_SCENES = {
	"bumper_circle": preload("res://game/tutorial/bumper_circle.tscn"),
	"bumper_pill": preload("res://game/tutorial/bumper_pill.tscn"),
	"wall_corner": preload("res://game/tutorial/wall_corner.tscn"),
	"gate": preload("res://game/tutorial/gate.tscn"),
}

const Ball = preload("res://game/core/ball.tscn")

const BALL_START_POSITION: Vector2 = Vector2(485, 730)
const BALL_PLUNGE_VELOCITY: Vector2 = Vector2(0, -1500)

var _balls_to_plunge := 0


func _ready():
	%DropZonePolygon2D.visible = false
	stop()


func _on_ball_plunge_timer_timeout():
	_plunge()


func _on_plunger_area_2d_body_exited(body: Node2D):
	if body.is_in_group("isBall"):
		var ball = body as RigidBody2D
		ball.set_collision_mask_value(2, true)


func _can_drop_data(at_position: Vector2, data):
	return data.is_toolbox_item && _is_in_allowed_area(at_position)


func _drop_data(at_position: Vector2, data):
	var component = COMPONENT_SCENES[data.component_id].instantiate() as Node2D
	component.position = at_position
	component.move_by_player_ended.connect(_on_move_by_player_ended)
	%PlayerComponents.add_child(component)
	_set_drop_zone_glow_enabled(false)
	GameStore.clear_drag_data()


func _on_drain_gutter_area_2d_body_entered(body: Node2D):
	if body.is_in_group("isBall"):
		Audio.play_random_sound_with($AudioStreamPlayer, SOUNDS_FOR_DRAINING)
		body.queue_free()
		var balls = get_tree().get_nodes_in_group("isBall")
		var nr_of_balls = balls.size()
		if nr_of_balls == 0 or (nr_of_balls == 1 and balls[0] == body):
			stop()
			GameStore.persist_progress()


func _on_mouse_entered():
	if GameStore.is_dragging:
		_set_drop_zone_glow_enabled(true)


func _on_mouse_exited():
	_set_drop_zone_glow_enabled(false)


func _on_gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		_set_drop_zone_glow_enabled(event.is_pressed())
		if not event.is_pressed():
			for child in %PlayerComponents.get_children():
				child.end_move()


func play(playbook):
	_balls_to_plunge = 1
	_init_play(playbook)


func stress_test(playbook):
	_balls_to_plunge = 10
	_init_play(playbook)


func stop():
	get_tree().paused = true
	%FlipperLeft.stop()
	%FlipperRight.stop()
	Audio.set_suppressed_music(false)


func _plunge():
	if _balls_to_plunge > 0:
		_balls_to_plunge -= 1
		Audio.play_random_sound_with($AudioStreamPlayer, SOUNDS_FOR_PLUNGING)
		var ball = Ball.instantiate() as RigidBody2D
		ball.position = BALL_START_POSITION
		ball.linear_velocity = BALL_PLUNGE_VELOCITY
		%MachineNode2D.add_child(ball)


func _set_drop_zone_glow_enabled(is_enabled: bool):
	%DropZonePolygon2D.visible = is_enabled
	if is_enabled:
		%DropZonePolygon2D/AnimationPlayer.seek(0)
		%DropZonePolygon2D/AnimationPlayer.play("drop_zone_glow")


func _on_move_by_player_ended(node: Node2D):
	if not _is_in_allowed_area(node.position):
		node.move_to_last_known_position()


func _init_play(playbook):
	%BallPlungeTimer.start(playbook.plunge_delay)
	Audio.set_suppressed_music(true)
	for ball in get_tree().get_nodes_in_group("isBall"):
		ball.queue_free()
	get_tree().paused = false
	get_tree().call_group("isResettablePinballComponent", "reset_pinball_component")
	%FlipperLeft.reset(playbook.flipper_left_interval)
	%FlipperRight.reset(playbook.flipper_right_interval)


func _is_in_allowed_area(at_position: Vector2) -> bool:
	return Geometry2D.is_point_in_polygon(at_position, %DropZonePolygon2D.polygon)
