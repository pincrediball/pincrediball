extends Control

signal credits_roll_requested()


func _ready():
	OptionsStore.load_options()
	%SoundCheckButton.set_pressed_no_signal(not Audio.has_muted_pinball_sfx())
	%MusicCheckButton.set_pressed_no_signal(not Audio.has_muted_music())
	%ContinueGameButton.disabled = not GameStore.can_continue_game
	%ProgressButton.disabled = not GameStore.can_continue_game


func _input(event: InputEvent):
	if event.is_action_pressed("ui_cancel") and $OptionsMenu.visible:
		$OptionsMenu.hide()


func _on_new_game_button_pressed():
	Audio.play_menu_button_sound_next()
	if GameStore.can_continue_game:
		%NewGameConfirmationDialog.show()
	else:
		GameStore.start_new_game()


func _on_continue_game_button_pressed():
	Audio.play_menu_button_sound_next()
	GameStore.continue_game()


func _on_progress_button_pressed():
	Audio.play_menu_button_sound_next()
	$Progress.show()


func _on_options_button_pressed():
	Audio.play_menu_button_sound_next()
	$OptionsMenu.show()


func _on_credits_button_pressed():
	Audio.play_menu_button_sound_next()
	credits_roll_requested.emit()


func _on_exit_button_pressed():
	Audio.play_menu_button_sound_back()
	%FadeToBlack.visible = true
	await get_tree().create_timer(0.25).timeout # let the sound play first
	get_tree().quit()


func _on_exit_options_button_pressed():
	Audio.play_menu_button_sound_back()
	OptionsStore.save_options()
	$OptionsMenu.hide()


func _on_sound_check_button_toggled(button_pressed: bool):
	Audio.play_menu_button_sound_next()
	Audio.set_mute_pinball_sfx(not button_pressed)


func _on_music_check_button_toggled(button_pressed: bool):
	Audio.play_menu_button_sound_next()
	Audio.set_mute_music(not button_pressed)


func _on_visibility_changed():
	%ContinueGameButton.disabled = not GameStore.can_continue_game
	%ProgressButton.disabled = not GameStore.can_continue_game


func _on_confirm_start_new_game_button_pressed():
	Audio.play_menu_button_sound_next()
	%NewGameConfirmationDialog.hide()
	GameStore.start_new_game()


func _on_cancel_start_new_game_button_pressed():
	Audio.play_menu_button_sound_back()
	%NewGameConfirmationDialog.hide()
