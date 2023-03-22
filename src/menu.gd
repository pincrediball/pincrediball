extends Control

signal credits_roll_requested()

func _on_new_game_button_pressed():
	self.visible = false


func _on_continue_game_button_pressed():
	pass # Replace with function body.


func _on_options_button_pressed():
	pass # Replace with function body.


func _on_credits_button_pressed():
	credits_roll_requested.emit()

func _on_exit_button_pressed():
	get_tree().quit()
