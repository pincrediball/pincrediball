extends Control

var stage;
var toolboxItemScene = preload("res://game/toolbox_item.tscn")

func _ready():
	stage = GameStore.get_current_stage()
	
	for child in %ItemsVBox.get_children():
		child.queue_free()
	
	for entry in stage.toolbox_items:
		var toolboxItem: Control = toolboxItemScene.instantiate()
		toolboxItem.load_pinball_component(entry)
		%ItemsVBox.add_child(toolboxItem)
