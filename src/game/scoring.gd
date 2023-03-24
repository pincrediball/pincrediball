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


func set_enabled(value: bool):
	is_enabled = value
	scoring_mode_toggled.emit(value)
