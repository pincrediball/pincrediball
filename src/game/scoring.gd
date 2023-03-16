extends Node

signal score_changed(from: int, to: int)

var currentScore: int = 0

func add_score(score: int = 0):
	var oldScore = currentScore
	currentScore += score
	score_changed.emit(oldScore, currentScore)

func reset_score():
	var oldScore = currentScore
	currentScore = 0
	score_changed.emit(oldScore, 0)
