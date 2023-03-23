extends PlayerControlledComponent

func _ready():
	super._ready()
	$ComponentArea2D.input_event.connect(_on_input_event_for_drag_hitbox)
	sounds_default = [
		preload("res://sound/wall-001.wav"),
		preload("res://sound/wall-002.wav"),
		preload("res://sound/wall-003.wav"),
		preload("res://sound/wall-004.wav"),
	]

