class_name ProgressForLevel
extends Resource

@export var stage: String
@export var level: int
@export var medals: int
@export var high_score: int

func _init(level: int):
	self.level = level


func update_for(score: int, medal_targets):
	assert(medal_targets.level == level)
	high_score = max(high_score, score)
	if high_score >= medal_targets.gold: medals = 3
	elif high_score >= medal_targets.silver: medals = 2
	elif high_score >= medal_targets.bronze: medals = 1
	else: medals = 0
