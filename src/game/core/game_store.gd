extends Node

signal new_game_started()
signal continue_game_requested()
signal menu_open_requested()
signal level_changed(level: int)
signal high_score_changed(to: int)
signal next_level_unlocked()
signal next_machine_unlocked()

const SAVE_PROGRESS_FILE_PATH = "user://progress.tres"

var drag_data: Dictionary = { }

var is_dragging: bool:
	get: return drag_data.size() > 0

var can_continue_game := false:
	get: return can_continue_game

var _machines = {
	"tutorial": null,
	"newb": null,
	"normie": null,
	"nasty": null,
	"nightmare": null,
}

var _current_level := 1
var _current_machine = null # TODO: Consider typing this
var _progress: Progress
var is_next_machine_unlocked := false


func _ready():
	_machines.tutorial = _read_machine("tutorial")
	_current_machine = _machines.tutorial
	_load_progress_for_user()


func clear_drag_data() -> void:
	drag_data = { }


func request_menu_open() -> void:
	menu_open_requested.emit()


func get_current_machine():
	return _current_machine
	

func get_current_level() -> int:
	return _current_level


func get_current_stage():
	for stage in _current_machine.stages:
		if stage.level == _current_level:
			return stage
	return null
	

func get_current_stage_high_score() -> int:
	for level_progress in _progress.stages:
		if level_progress.level == _current_level:
			return level_progress.high_score
	return 0


func get_progress() -> Progress:
	return _progress


func get_max_unlocked_level_for_machine(machine_key: String) -> int:
	return 0 if _progress == null else _progress.max_level_per_machine[machine_key]


func is_at_max_level_for_current_machine() -> bool:
	return _current_level >= len(_current_machine.stages)


func is_at_max_progression_level_for_current_machine() -> bool:
	return _current_level >= _progress.max_level_per_machine[_current_machine.key]


func start_new_game() -> void:
	_current_level = 1
	is_next_machine_unlocked = false
	_progress = Progress.new(_machines)
	can_continue_game = true
	new_game_started.emit()


func continue_game() -> void:
	continue_game_requested.emit()


func jump_to_level(level: int) -> void:
	assert(level > 0)
	assert(level <= len(_current_machine.stages))
	_current_level = level
	level_changed.emit(level)


func persist_progress() -> void:
	if Scoring.is_enabled:
		var score = Scoring.get_current_score()
		var was_next_machine_already_unlocked = is_next_machine_unlocked
		for level_progress in _progress.stages:
			if level_progress.level == _current_level:
				var stage = get_current_stage()
				var was_new_high_score = score > level_progress.high_score
				
				level_progress.update_for(score, stage)
				
				var is_new_level_unlocked = \
					level_progress.medals > 0 \
					and was_new_high_score \
					and is_at_max_progression_level_for_current_machine() \
					and not is_at_max_level_for_current_machine()
				
				if is_new_level_unlocked:
					_progress.max_level_per_machine[_current_machine.key] = _current_level + 1
				
				is_next_machine_unlocked = _progress.stages.all(func(x): return x.medals > 0)
				
				_save_progress_for_user()
				
				# Emit signals as the last thing, and in the right order:
				if was_new_high_score:
					high_score_changed.emit(score)
				if is_new_level_unlocked:
					next_level_unlocked.emit()
				if not was_next_machine_already_unlocked and is_next_machine_unlocked:
					next_machine_unlocked.emit()


func _save_progress_for_user():
	ResourceSaver.save(_progress, SAVE_PROGRESS_FILE_PATH)


func _load_progress_for_user():
	if not ResourceLoader.exists(SAVE_PROGRESS_FILE_PATH):
		return
	_progress = load(SAVE_PROGRESS_FILE_PATH)
	_current_level = _progress.max_level_per_machine[_current_machine.key]
	is_next_machine_unlocked = _progress.stages.all(func(x): return x.medals > 0)
	can_continue_game = true


func _read_machine(key: String):
	var fileName = "res://game/%s/machine_data.json" % key
	var file = FileAccess.open(fileName, FileAccess.READ)
	var contents = file.get_as_text()
	file.close()
	return JSON.parse_string(contents)
