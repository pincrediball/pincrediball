extends PlayerControlledStaticBody2D

func _ready():
	super._ready()
	sounds = [
		preload("res://sound/wall-001.wav"),
		preload("res://sound/wall-002.wav"),
		preload("res://sound/wall-003.wav"),
		preload("res://sound/wall-004.wav"),
	]

