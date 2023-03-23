extends Node

signal new_game_started()
signal continue_game_requested()
signal menu_open_requested()

@export var drag_data: Dictionary

@export var is_dragging: bool:
	get: return drag_data.size() > 0

@export var can_continue_game := false:
	get: return can_continue_game

var current_level := 6
var current_stage

func _ready():
	current_stage = _read_stage("tutorial")

func _read_stage(stage: String):
	var fileName = "res://game/%s/stage_data.json" % stage # Hardcoded for now
	var file = FileAccess.open(fileName, FileAccess.READ)
	var contents = file.get_as_text()
	file.close()
	return JSON.parse_string(contents)

func clearDragData():
	drag_data = { }

func request_menu_open():
	menu_open_requested.emit()

func get_current_stage():
	return current_stage
	
func get_current_level():
	return current_level

func get_current_playbook():
	for playbook in current_stage.playbooks:
		if playbook.level == current_level:
			return playbook
	return null

func start_new_game():
	current_level = 1
	new_game_started.emit()
	can_continue_game = true

func continue_game():
	# TODO: Build loading game from user folder
	# For now this only works if there is a game running
	continue_game_requested.emit()
