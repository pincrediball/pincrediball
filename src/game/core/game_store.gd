extends Node

signal new_game_started()
signal continue_game_requested()
signal menu_open_requested()
signal level_changed()
signal high_score_changed(to: int)

var drag_data: Dictionary = { }

var is_dragging: bool:
	get: return drag_data.size() > 0

var can_continue_game := false:
	get: return can_continue_game

var _stages = {
	"tutorial": null,
}

var _current_level := 6
var _current_stage = null # TODO: Consider typing this
var _progress: Progress


func _ready():
	_stages.tutorial = _read_stage("tutorial")
	_current_stage = _stages.tutorial


func clear_drag_data() -> void:
	drag_data = { }


func request_menu_open() -> void:
	menu_open_requested.emit()


func get_current_stage():
	return _current_stage
	

func get_current_level() -> int:
	return _current_level


func get_current_playbook():
	for playbook in _current_stage.playbooks:
		if playbook.level == _current_level:
			return playbook
	return null


func get_current_medal_targets():
	for medal_target in _current_stage.medal_targets:
		if medal_target.level == _current_level:
			return medal_target
	return null


func get_progress() -> Progress:
	return _progress


func start_new_game() -> void:
	_current_level = 1
	can_continue_game = true
	_progress = Progress.new(_stages)
	new_game_started.emit()


func continue_game() -> void:
	# TODO: Build loading game from user folder
	# For now this only works if there is a game running
	continue_game_requested.emit()


func jump_to_level(level: int) -> void:
	_current_level = level
	level_changed.emit()


func persist_progress() -> void:
	if Scoring.is_enabled:
		var score = Scoring.get_current_score()
		for level_progress in _progress.levels:
			if level_progress.level == _current_level:
				var medal_targets = get_current_medal_targets()
				var was_new_high_score = score > level_progress.high_score
				level_progress.update_for(score, medal_targets)
				if was_new_high_score:
					high_score_changed.emit(score)


func _read_stage(stage: String):
	var fileName = "res://game/%s/stage_data.json" % stage # Hardcoded for now
	var file = FileAccess.open(fileName, FileAccess.READ)
	var contents = file.get_as_text()
	file.close()
	return JSON.parse_string(contents)
