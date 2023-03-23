extends Control

var stage;
var toolboxItemScene = preload("res://game/toolbox_item.tscn")

func _ready():
	stage = GameStore.getCurrentStage()
	loadStage(stage)

func loadStage(stage):
	for child in %ItemsVBox.get_children():
		child.queue_free()
	
	for entry in stage.toolbox.items:
		var toolboxItem: Control = toolboxItemScene.instantiate()
		toolboxItem.load_pinball_component(entry)
		%ItemsVBox.add_child(toolboxItem)
