extends Node

signal score_changed(from: int, to: int)
signal scoring_mode_toggled(enabled: bool)

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


# TODO: Turn this into setter for the public var
func set_enabled(value: bool):
	is_enabled = value
	scoring_mode_toggled.emit(value)


func get_current_score():
	return _current_score


# Whelp! GDScript doesn't have much formatting, does it? Apparently we 
# have to write this stuff ourselves? Also no StringBuilder or similar
# so this'll have to do... 
# Adapted from https://godotengine.org/qa/18559/how-to-add-commas-to-an-integer-or-float-in-gdscript
static func format_score(score: int) -> String:
	var result = "%s" % score
	var i : int = result.length() - 3
	while i > 0:
		result = result.insert(i, ",")
		i = i - 3
	return result
