extends Control

signal menu_open_requested()

var _was_paused := true


func reset_pause_state():
	get_tree().paused = _was_paused


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
	GameStore.request_menu_open()


func _on_debug_option_unlock_all_levels_button_pressed():
	GameStore.jump_to_level(6)
