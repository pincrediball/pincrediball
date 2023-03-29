extends Control


func _ready():
	if GameStore.is_next_machine_unlocked:
		_enable_self()
	GameStore.next_machine_unlocked.connect(_on_next_machine_unlocked)


func _on_rich_text_label_meta_clicked(meta):
	Audio.play_menu_button_sound_next()
	OS.shell_open(str(meta))


func _on_continue_playing_button_pressed():
	Audio.play_menu_button_sound_next()
	self.visible = false


func _on_show_credits_button_pressed():
	Audio.play_menu_button_sound_next()
	var credits = load("res://menu/credits.tscn").instantiate() as Control
	add_child(credits)


func _on_back_to_menu_button_pressed():
	Audio.play_menu_button_sound_back()
	self.visible = false
	GameStore.request_menu_open()


func _on_next_machine_unlocked():
	_enable_self()


func _enable_self():
	self.visible = true
	Audio.start_music_for_victory()

