class_name ProgressForStage
extends Resource

@export var machine_key: String
@export var level: int
@export var medals: int
@export var high_score: int


# Default value required for save/load
func _init(_machine_key: String = "", _level: int = 0):
	machine_key = _machine_key
	level = _level


func update_for(score: int, stage):
	assert(stage.level == level)
	high_score = max(high_score, score)
	if high_score >= stage.gold: medals = 3
	elif high_score >= stage.silver: medals = 2
	elif high_score >= stage.bronze: medals = 1
	else: medals = 0
