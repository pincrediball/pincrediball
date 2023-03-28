extends Control

const textures = {
	"bumper_circle": preload("res://art/game/tutorial/component_bumper_circle.png"),
	"bumper_pill": preload("res://art/game/tutorial/component_bumper_pill.png"),
	"wall_corner": preload("res://art/game/tutorial/component_wall_corner.png"),
	"gate": preload("res://art/game/tutorial/component_gate.png"),
}

var is_disabled := false:
	get:
		return is_disabled
	set(value):
		is_disabled = value
		%OverlayUnlocksAt.visible = value

var _toolbox_item_data


func _ready():
	GameStore.level_changed.connect(_on_level_changed)
	GameStore.next_level_unlocked.connect(_on_next_level_unlocked)


func _get_drag_data(_position):
	var icon = TextureRect.new()
	var preview = Control.new()
	icon.texture = %TextureRect.texture
	icon.position = icon.texture.get_size() * -0.5
	preview.add_child(icon)
	preview.z_index = 60
	preview.modulate = Color(1, 1, 1, 0.5)
	set_drag_preview(preview)
	var drag_data = { component_id = _toolbox_item_data.component_id, is_toolbox_item = true }
	GameStore.drag_data = drag_data
	return drag_data


func load_pinball_component(data):
	%TitleLabel.text = data.title
	%DescriptionLabel.text = data.description
	%TextureRect.texture = textures[data.component_id]
	%UnlocksAtLabel.text = "Unlocks at level %s" % data.unlocks_at
	is_disabled = data.unlocks_at > GameStore.get_current_level()
	_toolbox_item_data = data


func _on_level_changed(level: int):
	is_disabled = _toolbox_item_data.unlocks_at > level
	%OverlayJustUnlocked.visible = false


func _on_next_level_unlocked():
	if _toolbox_item_data.unlocks_at == GameStore.get_current_level() + 1:
		%OverlayJustUnlocked.visible = true
		%OverlayUnlocksAt.visible = false
		%UnlockAnimationPlayer.play()


func _on_more_info_button_pressed():
	Audio.play_menu_button_sound_next() if %TitleLabel.visible else Audio.play_menu_button_sound_back()
	%TitleLabel.visible = not %TitleLabel.visible
	%DescriptionLabel.visible = not %DescriptionLabel.visible


func _on_overlay_just_unlocked_gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		Audio.play_menu_button_sound_next()
		GameStore.jump_to_level(_toolbox_item_data.unlocks_at)
