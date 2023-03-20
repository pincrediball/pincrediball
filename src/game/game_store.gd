extends Node

signal level_changed(to: int)

@export var currentLevel: int = 1:
	get:
		return currentLevel

var currentStage

func _ready():
	currentStage = _readStageJson("tutorial")

func _readStageJson(stage: String):
	var fileName = "res://game/%s/stage_data.json" % stage # Hardcoded for now
	var file = FileAccess.open(fileName, FileAccess.READ)
	var contents = file.get_as_text()
	file.close()
	return JSON.parse_string(contents)

func getCurrentStage():
	return currentStage
