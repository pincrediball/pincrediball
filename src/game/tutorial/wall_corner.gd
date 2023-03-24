extends PlayerControlledComponent

func _ready():
	super._ready()
	_sounds_default = [
		preload("res://sound/wall-001.wav"),
		preload("res://sound/wall-002.wav"),
		preload("res://sound/wall-003.wav"),
		preload("res://sound/wall-004.wav"),
	]

func _unhandled_input(event): _handle_unhandled_input(event)
func _on_component_area_2d_mouse_entered(): _is_mouse_over_body = true
func _on_component_area_2d_mouse_exited(): _is_mouse_over_body = false
