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

func _ready():
	%DropZonePolygon2D.visible = false
	stop()

func play(levelPlaybook):
	Audio.set_suppressed_music(true)
	get_tree().paused = false
	get_tree().call_group("isResettablePinballComponent", "resetPinballComponent")
	%FlipperLeft.reset(levelPlaybook.flipper_left_interval)
	%FlipperRight.reset(levelPlaybook.flipper_right_interval)
	get_tree().create_timer(levelPlaybook.plunge_delay).connect("timeout", plunge)

func stop():
	get_tree().paused = true
	%FlipperLeft.stop()
	%FlipperRight.stop()
	Audio.set_suppressed_music(false)

func plunge():
	$AudioStreamPlayer.stream = soundsPlunge[randi() % len(soundsPlunge)]
	$AudioStreamPlayer.play()
	var ball: RigidBody2D = ballScene.instantiate()
	ball.position = ballStartPosition
	ball.linear_velocity = ballPlungeVelocity
	%MachineNode2D.add_child(ball)

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

func _can_drop_data(at_position, data):
	var is_in_allowed_area = Geometry2D.is_point_in_polygon(at_position, %DropZonePolygon2D.polygon)
	return data.is_toolbox_item && is_in_allowed_area

func _drop_data(at_position, data):
	var component = component_scenes[data.component_id].instantiate() as Node2D
	component.position = at_position
	%MachineNode2D.add_child(component)
	%DropZonePolygon2D.visible = false
	GameStore.clearDragData()

func _on_mouse_entered():
	if GameStore.drag_data.has("is_toolbox_item"):
		%DropZonePolygon2D.visible = true
		%DropZonePolygon2D/AnimationPlayer.seek(0)
		%DropZonePolygon2D/AnimationPlayer.play("drop_zone_glow")

func _on_mouse_exited():
	%DropZonePolygon2D.visible = false
