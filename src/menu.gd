extends Control

signal credits_roll_requested()

func _ready():
	%SoundCheckButton.set_pressed_no_signal(not Audio.has_muted_pinball_sfx())
	%MusicCheckButton.set_pressed_no_signal(not Audio.has_muted_music())

func _input(event: InputEvent):
	if event.is_action_pressed("ui_cancel") and $OptionsMenu.visible:
		$MainMenu.visible = true
		$OptionsMenu.visible = false

func _on_new_game_button_pressed():
	Audio.play_random_menu_button_sound()
	GameStore.start_new_game()

func _on_continue_game_button_pressed():
	Audio.play_random_menu_button_sound()
	GameStore.continue_game()

func _on_options_button_pressed():
	Audio.play_random_menu_button_sound()
	$MainMenu.visible = false
	$OptionsMenu.visible = true

func _on_credits_button_pressed():
	Audio.play_random_menu_button_sound()
	credits_roll_requested.emit()

func _on_exit_button_pressed():
	Audio.play_random_menu_button_sound()
	await get_tree().create_timer(0.25).timeout # let the sound play first
	get_tree().quit()

func _on_exit_options_button_pressed():
	Audio.play_random_menu_button_sound()
	$MainMenu.visible = true
	$OptionsMenu.visible = false

func _on_sound_check_button_toggled(button_pressed):
	Audio.play_random_menu_button_sound()
	Audio.set_mute_pinball_sfx(not button_pressed)

func _on_music_check_button_toggled(button_pressed):
	Audio.play_random_menu_button_sound()
	Audio.set_mute_music(not button_pressed)

func _on_visibility_changed():
	%ContinueGameButton.disabled = not GameStore.can_continue_game
