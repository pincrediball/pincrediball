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
@export var medal_counts = {
	"tutorial": {
		"bronze": 0,
		"silver": 0,
		"gold": 0,
		"total": 0,
	}
}

# Default value required for save/load
func _init(machines: Dictionary = {}):
	for key in machines:
		var machine = machines[key]
		if machine == null:
			continue
		for stage in machine.stages:
			var stage_progress = ProgressForStage.new(key, stage.level)
			stages.append(stage_progress)
			if stage_progress.medals > 0:
				max_level_per_machine[key] = max(max_level_per_machine[key], stage_progress.level)
		_update_medal_counts_for_machine(key)


func recalculate_medal_counts_for(machine_key: String):
	_update_medal_counts_for_machine(machine_key)


func _update_medal_counts_for_machine(machine_key: String):
	medal_counts[machine_key] = {
		"bronze": 0,
		"silver": 0,
		"gold": 0,
		"total": 0,
	}
	for stage in stages:
		if stage.machine_key != machine_key: continue
		if stage.medals > 0: medal_counts[machine_key]["bronze"] += 1
		if stage.medals > 1: medal_counts[machine_key]["silver"] += 1
		if stage.medals > 2: medal_counts[machine_key]["gold"] += 1
		medal_counts[machine_key]["total"] += stage.medals
