extends Camera2D

var _time_pressure := Scoring.TimePressure.LOW

func _ready():
	Scoring.time_left_changed.connect(_on_time_left_changed)
	Scoring.time_ran_out.connect(_on_time_ran_out)
	GameStore.level_changed.connect(_on_level_changed)


func _process(delta: float) -> void:
	var strength: float = 0.0
	
	match _time_pressure:
		Scoring.TimePressure.LOW:
			return
		Scoring.TimePressure.MEDIUM:
			strength = 0.5
		Scoring.TimePressure.HIGH:
			strength = 1.5
	
	offset = Vector2(
		randf_range(-strength, strength),
		randf_range(-strength, strength)
	)


func _on_time_left_changed(_to: float, pressure):
	_time_pressure = pressure


func _on_time_ran_out():
	_time_pressure = Scoring.TimePressure.LOW


func _on_level_changed(_level: int):
	_time_pressure = Scoring.TimePressure.LOW

