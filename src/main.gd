extends Control

func open_menu():
	get_tree().paused = true
	$Menu.visible = true
	Audio.set_suppressed_music(false)

func _input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"):
		open_menu()

func _on_game_menu_open_requested():
	open_menu()
