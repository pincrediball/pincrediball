extends Control

signal credits_roll_requested()

func _on_new_game_button_pressed():
	Audio.play_random_menu_button_sound()
	self.visible = false

func _on_continue_game_button_pressed():
	Audio.play_random_menu_button_sound()
	pass # Replace with function body.

func _on_options_button_pressed():
	Audio.play_random_menu_button_sound()
	pass # Replace with function body.

func _on_credits_button_pressed():
	Audio.play_random_menu_button_sound()
	credits_roll_requested.emit()

func _on_exit_button_pressed():
	Audio.play_random_menu_button_sound()
	await get_tree().create_timer(0.25).timeout # let the sound play first
	get_tree().quit()
