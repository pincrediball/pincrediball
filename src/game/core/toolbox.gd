extends Control

const ToolboxItem = preload("res://game/core/toolbox_item.tscn")

var machine = null


func _ready():
	machine = GameStore.get_current_machine()
	
	for child in %ItemsVBox.get_children():
		child.queue_free()
	
	for entry in machine.toolbox_items:
		var toolboxItem: Control = ToolboxItem.instantiate()
		toolboxItem.load_pinball_component(entry)
		%ItemsVBox.add_child(toolboxItem)
