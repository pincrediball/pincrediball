extends Control

func _ready():
	Audio.startGameMusic()
	GameStore.new_game_started.connect(_on_new_game_started)
	GameStore.continue_game_requested.connect(_on_continue_game_requested)
	GameStore.menu_open_requested.connect(_on_game_menu_open_requested)

func set_menu_opened(menu_should_be_open: bool):
	get_tree().paused = menu_should_be_open
	$Menu.visible = menu_should_be_open
	if menu_should_be_open:
		Audio.set_suppressed_music(false)

func reset_game_scene():
	for child in $GameContainer.get_children():
		child.queue_free()
	var game_scene = load("res://game.tscn").instantiate() as Control
	game_scene.set_anchors_preset(Control.PRESET_FULL_RECT)
	$GameContainer.add_child(game_scene)

func _input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"):
		set_menu_opened(true)

func _on_game_menu_open_requested():
	set_menu_opened(true)

func _on_menu_credits_roll_requested():
	var credits = load("res://credits.tscn").instantiate()
	add_child(credits)

func _on_new_game_started():
	reset_game_scene()
	set_menu_opened(false)

func _on_continue_game_requested():
	set_menu_opened(false)
