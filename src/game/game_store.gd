extends Node

signal new_game_started()
signal continue_game_requested()
signal menu_open_requested()

@export var drag_data: Dictionary

@export var is_dragging: bool:
	get: return drag_data.size() > 0

@export var currentLevel: int = 1:
	get:
		return currentLevel

@export var can_continue_game: bool = false:
	get: return can_continue_game

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

func clearDragData():
	drag_data = { }

func request_menu_open():
	menu_open_requested.emit()

func start_new_game():
	currentLevel = 1
	new_game_started.emit()
	can_continue_game = true

func continue_game():
	# TODO: Build loading game from user folder
	# For now this only works if there is a game running
	continue_game_requested.emit()
