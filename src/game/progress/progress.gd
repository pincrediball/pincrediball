class_name Progress
extends Resource

@export var version := 1
@export var levels: Array[ProgressForLevel] = []

func _init(stages):
	for key in stages:
		var stage = stages[key]
		for medal_target in stage.medal_targets:
			var level_progress = ProgressForLevel.new(medal_target.level)
			levels.append(level_progress)
