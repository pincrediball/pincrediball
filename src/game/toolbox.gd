extends Control

const ToolboxItem = preload("res://game/toolbox_item.tscn")

var stage = null


func _ready():
	stage = GameStore.get_current_stage()
	
	for child in %ItemsVBox.get_children():
		child.queue_free()
	
	for entry in stage.toolbox_items:
		var toolboxItem: Control = ToolboxItem.instantiate()
		toolboxItem.load_pinball_component(entry)
		%ItemsVBox.add_child(toolboxItem)
