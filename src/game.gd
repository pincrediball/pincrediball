extends Control

var playbooksByLevel = {
	1: preload("res://game/tutorial/playbook_level_001.tres"),
}

@export var currentLevel: int:
	get:
		return currentLevel
	set(value):
		currentLevel = value
		currentLevelPlaybook = playbooksByLevel[currentLevel]

var currentLevelPlaybook: Resource

func _ready():
	currentLevel = 1
	%Playbook.playbookResource = currentLevelPlaybook
	Music.startGameMusic()

func _on_button_button_up():
	Scoring.reset_score()
	%machine.play(currentLevelPlaybook)
