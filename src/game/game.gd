extends Control

signal menu_open_requested()

var _was_paused := true


func _ready():
	%FullScreenButton.disabled = OS.has_feature("IS_WEB")
	%FullScreenButton.modulate = Color(1, 1, 1, 0) if OS.has_feature("IS_WEB") else Color(1, 1, 1, 1)


func reset_pause_state():
	get_tree().paused = _was_paused
	Audio.set_suppressed_music(not _was_paused)


func _on_run_playbook_button_button_up():
	Audio.play_menu_button_sound_next()
	Scoring.reset_score()
	Scoring.set_enabled(true)
	%machine.play(GameStore.get_current_stage())


func _on_stress_test_button_button_up():
	Audio.play_menu_button_sound_next()
	Scoring.reset_score()
	Scoring.set_enabled(false)
	%machine.stress_test(GameStore.get_current_stage())


func _on_back_to_menu_button_pressed():
	Audio.play_menu_button_sound_back()
	_was_paused = get_tree().paused
	get_tree().paused = true
	GameStore.request_menu_open()


func _on_full_screen_button_pressed():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_MAXIMIZED:
		Audio.play_menu_button_sound_back()
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		%FullScreenButton.texture_normal = load("res://art/menu/menu_button_fullscreen_normal.png")
		%FullScreenButton.texture_pressed = load("res://art/menu/menu_button_fullscreen_pressed.png")
		%FullScreenButton.texture_hover = load("res://art/menu/menu_button_fullscreen_hover.png")
		%FullScreenButton.texture_disabled = load("res://art/menu/menu_button_fullscreen_disabled.png")
	else:
		Audio.play_menu_button_sound_next()
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
		%FullScreenButton.texture_normal = load("res://art/menu/menu_button_nonfullscreen_normal.png")
		%FullScreenButton.texture_pressed = load("res://art/menu/menu_button_nonfullscreen_pressed.png")
		%FullScreenButton.texture_hover = load("res://art/menu/menu_button_nonfullscreen_hover.png")
		%FullScreenButton.texture_disabled = load("res://art/menu/menu_button_nonfullscreen_disabled.png")
