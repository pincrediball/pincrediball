class_name Progress
extends Resource

@export var version := 1
@export var levels: Array[ProgressForLevel] = []
@export var max_level_per_stage = {
	"tutorial": 1,
	"newb": 1,
	"normie": 1,
	"nasty": 1,
	"nightmare": 1,
}

func _init(stages):
	for key in stages:
		var stage = stages[key]
		if stage == null:
			continue
		for medal_target in stage.medal_targets:
			var level_progress = ProgressForLevel.new(medal_target.level)
			levels.append(level_progress)
			if level_progress.medals > 0:
				max_level_per_stage[key] = max(max_level_per_stage[key], level_progress.level)
