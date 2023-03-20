extends Control

const textures = {
	"bumper_circle": preload("res://art/game/tutorial/component_bumper_circle.png"),
	"bumper_pill": preload("res://art/game/tutorial/component_bumper_pill.png"),
	"wall_corner": preload("res://art/game/tutorial/component_wall_corner.png"),
	"gate": preload("res://art/game/tutorial/component_gate.png"),
}

var isDisabled := false:
	get:
		return isDisabled
	set(value):
		isDisabled = value
		%Overlay.visible = value

func load(data):
	%RichTextLabel.text = "[b]%s[/b]\n[font_size=10]%s[/font_size]" % [data.title, data.description]
	%TextureRect.texture = textures[data.component_id]
	%UnlocksAtLabel.text = "Unlocks at level %s" % data.unlocks_at
	isDisabled = data.unlocks_at > GameStore.currentLevel
