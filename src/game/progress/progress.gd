class_name Progress
extends Resource

@export var version := 1
@export var stages: Array[ProgressForStage] = []
@export var max_level_per_machine = {
	"tutorial": 1,
	"newb": 1,
	"normie": 1,
	"nasty": 1,
	"nightmare": 1,
}

# Default value required for save/load
func _init(machines: Dictionary = {}):
	for key in machines:
		var machine = machines[key]
		if machine == null:
			continue
		for stage in machine.stages:
			var stage_progress = ProgressForStage.new(stage.level)
			stages.append(stage_progress)
			if stage_progress.medals > 0:
				max_level_per_machine[key] = max(max_level_per_machine[key], stage_progress.level)
