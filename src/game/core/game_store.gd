extends Node

signal new_game_started()
signal continue_game_requested()
signal menu_open_requested()
signal level_changed(level: int)
signal high_score_changed(to: int)
signal next_level_unlocked()

var drag_data: Dictionary = { }

var is_dragging: bool:
	get: return drag_data.size() > 0

var can_continue_game := false:
	get: return can_continue_game

var _stages = {
	"tutorial": null,
	"newb": null,
	"normie": null,
	"nasty": null,
	"nightmare": null,
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
	

func get_current_level_high_score() -> int:
	for level_progress in _progress.levels:
		if level_progress.level == _current_level:
			return level_progress.high_score
	return 0


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


func is_at_max_stage_level() -> bool:
	return _current_level >= len(_current_stage.medal_targets)


func is_at_max_progression_level() -> bool:
	return _current_level >= _progress.max_level_per_stage[_current_stage.key]


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
	assert(level > 0)
	_current_level = level
	level_changed.emit(level)


func persist_progress() -> void:
	if Scoring.is_enabled:
		var score = Scoring.get_current_score()
		for level_progress in _progress.levels:
			if level_progress.level == _current_level:
				var medal_targets = get_current_medal_targets()
				var was_new_high_score = score > level_progress.high_score
				
				level_progress.update_for(score, medal_targets)
				
				var is_new_level_unlocked = \
					level_progress.medals > 0 \
					and was_new_high_score \
					and is_at_max_progression_level() \
					and not is_at_max_stage_level()
				
				if is_new_level_unlocked:
					_progress.max_level_per_stage[_current_stage.key] = _current_level + 1

				# Emit signals as the last thing, and in the right order:
				if was_new_high_score:
					high_score_changed.emit(score)
				if is_new_level_unlocked:
					next_level_unlocked.emit()


func _read_stage(stage: String):
	var fileName = "res://game/%s/stage_data.json" % stage # Hardcoded for now
	var file = FileAccess.open(fileName, FileAccess.READ)
	var contents = file.get_as_text()
	file.close()
	return JSON.parse_string(contents)
