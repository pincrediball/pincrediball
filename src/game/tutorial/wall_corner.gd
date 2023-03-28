extends PlayerControlledComponent

func _ready():
	super._ready()
	_sounds_default = [
		preload("res://sound/wall-normal-001.wav"),
	]

func _unhandled_input(event): _handle_unhandled_input(event)
func _on_component_area_2d_mouse_entered(): _is_mouse_over_body = true
func _on_component_area_2d_mouse_exited(): _is_mouse_over_body = false


func _set_ethereal(is_ethereal: bool):
	$StaticBody2D.set_collision_layer_value(1, not is_ethereal)
	$StaticBody2D.set_collision_mask_value(1, not is_ethereal)
