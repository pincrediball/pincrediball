extends VBoxContainer

var _current_level := 1
var _max_level_visited := 1


func _ready():
	_max_level_visited = GameStore.get_current_level()
	_load_level(_max_level_visited)
	GameStore.level_changed.connect(_on_level_changed)
	GameStore.high_score_changed.connect(_on_high_score_changed)
	GameStore.next_level_unlocked.connect(_on_next_level_unlocked)


func _load_level(level: int):
	_current_level = level
	var medal_targets = GameStore.get_current_medal_targets()
	%LevelNumberLabel.text = "Level %s:" % level
	%LevelTitleLabel.text = '"%s"' % medal_targets.title
	%PreviousLevelButton.disabled = level <= 1
	%NextLevelButton.disabled = GameStore.is_at_max_progression_level() or GameStore.is_at_max_stage_level()
	%NextLevelButton.modulate = Color(1,1,1,0) if GameStore.is_at_max_stage_level() else Color(1,1,1,1)


func _on_next_level_unlocked():
	%NextLevelButtonAnimation.current_animation = "flashing"
	%NextLevelButtonAnimation.play()


func _on_high_score_changed(_to: int):
	_load_level(GameStore.get_current_level())


func _on_level_changed(level: int):
	_current_level = level
	_load_level(level)


func _on_previous_level_button_pressed():
	Audio.play_menu_button_sound_back()
	%NextLevelButtonAnimation.stop()
	GameStore.jump_to_level(_current_level - 1)


func _on_next_level_button_pressed():
	Audio.play_menu_button_sound_next()
	%NextLevelButtonAnimation.stop()
	GameStore.jump_to_level(_current_level + 1)
