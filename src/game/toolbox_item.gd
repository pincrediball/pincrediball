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

var component_id: String

func load(data):
	%RichTextLabel.text = "[b]%s[/b]\n[font_size=10]%s[/font_size]" % [data.title, data.description]
	%TextureRect.texture = textures[data.component_id]
	%UnlocksAtLabel.text = "Unlocks at level %s" % data.unlocks_at
	is_disabled = data.unlocks_at > GameStore.currentLevel
	component_id = data.component_id

func _get_drag_data(_position):
	var icon = TextureRect.new()
	var preview = Control.new()
	icon.texture = %TextureRect.texture
	icon.position = icon.texture.get_size() * -0.5
	preview.add_child(icon)
	preview.z_index = 60
	set_drag_preview(preview)
	return { component_id = component_id, is_toolbox_item = true }
