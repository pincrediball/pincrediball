extends Camera2D

var shake_strength: float = 0.0

func _ready():
	Scoring.time_left_changed.connect(_on_time_left_changed)
	Scoring.time_ran_out.connect(_on_time_ran_out)
	_set_pressure(Scoring.TimePressure.LOW)

func _process(delta: float) -> void:
	var shake_offset := Vector2(
		randf_range(-shake_strength, shake_strength),
		randf_range(-shake_strength, shake_strength)
	)
	offset = shake_offset


func _on_time_left_changed(_to: float, pressure):
	_set_pressure(pressure)


func _on_time_ran_out():
	_set_pressure(Scoring.TimePressure.LOW)


func _set_pressure(pressure):
	match pressure:
		Scoring.TimePressure.HIGH:
			shake_strength = 2.5
			process_mode = Node.PROCESS_MODE_INHERIT
		Scoring.TimePressure.MEDIUM:
			shake_strength = 0.5
			process_mode = Node.PROCESS_MODE_INHERIT
		_:
			offset = Vector2(0, 0)
			process_mode = Node.PROCESS_MODE_DISABLED
