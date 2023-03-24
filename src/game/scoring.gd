extends Node

signal score_changed(from: int, to: int)
signal scoring_mode_toggled(enabled: bool)

var currentScore: int = 0
var is_enabled: bool = true


func add_score(score: int = 0):
	if is_enabled:
		var oldScore = currentScore
		currentScore += score
		score_changed.emit(oldScore, currentScore)


func reset_score():
	var oldScore = currentScore
	currentScore = 0
	score_changed.emit(oldScore, 0)


func set_enabled(value: bool):
	is_enabled = value
	scoring_mode_toggled.emit(value)
