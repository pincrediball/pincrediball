extends Node

enum TimePressure { LOW, MEDIUM, HIGH }

signal score_changed(from: int, to: int)
signal scoring_mode_toggled(enabled: bool)
signal time_left_changed(to: float, pressure: TimePressure)
signal time_ran_out()

var is_enabled: bool = true
var _current_score: int = 0


func add_score(score: int = 0):
	if is_enabled:
		var oldScore = _current_score
		_current_score += score
		score_changed.emit(oldScore, _current_score)


func reset_score():
	var oldScore = _current_score
	_current_score = 0
	score_changed.emit(oldScore, 0)


func set_enabled(value: bool):
	is_enabled = value
	scoring_mode_toggled.emit(value)


func get_current_score():
	return _current_score


func update_time_left_to(time_left: float):
	var time_pressure = TimePressure.LOW
	if time_left <= 2.0:
		time_pressure = TimePressure.HIGH
	elif time_left <= 5.0:
		time_pressure = TimePressure.MEDIUM
	time_left_changed.emit(max(time_left, 0.0), time_pressure)
	if time_left <= 0.0:
		time_ran_out.emit()


# Whelp! GDScript doesn't have much formatting, does it? Apparently we 
# have to write this stuff ourselves? Also no StringBuilder or similar
# so this'll have to do... 
# Adapted from https://godotengine.org/qa/18559/how-to-add-commas-to-an-integer-or-float-in-gdscript
func format_score(score: int, pad_to_total: int = 0) -> String:
	var result = "%s" % score
	var i : int = result.length() - 3
	while i > 0:
		result = result.insert(i, ",")
		i = i - 3
	var format = str("%", pad_to_total, "s") if pad_to_total > 0 else "%s"
	return format % result
