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
		%Overlay.visible = value

var _stage_data


func _ready():
	GameStore.level_changed.connect(_on_level_changed)


func _get_drag_data(_position):
	var icon = TextureRect.new()
	var preview = Control.new()
	icon.texture = %TextureRect.texture
	icon.position = icon.texture.get_size() * -0.5
	preview.add_child(icon)
	preview.z_index = 60
	set_drag_preview(preview)
	var drag_data = { component_id = _stage_data.component_id, is_toolbox_item = true }
	GameStore.drag_data = drag_data
	return drag_data


func load_pinball_component(data):
	%TitleLabel.text = data.title
	%DescriptionLabel.text = data.description
	%TextureRect.texture = textures[data.component_id]
	%UnlocksAtLabel.text = "Unlocks at level %s" % data.unlocks_at
	is_disabled = data.unlocks_at > GameStore.get_current_level()
	_stage_data = data


func _on_level_changed(level: int):
	is_disabled = _stage_data.unlocks_at > level


func _on_more_info_button_pressed():
	Audio.play_menu_button_sound_next() if %TitleLabel.visible else Audio.play_menu_button_sound_back()
	%TitleLabel.visible = not %TitleLabel.visible
	%DescriptionLabel.visible = not %DescriptionLabel.visible
