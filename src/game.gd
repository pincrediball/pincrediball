extends Control

var playbooksByLevel = {
	1: preload("res://game/tutorial/playbook_level_001.tres"),
}

var currentLevelPlaybook: Resource

func _ready():
	currentLevelPlaybook = playbooksByLevel[GameStore.currentLevel]
	%Playbook.playbookResource = currentLevelPlaybook
	Music.startGameMusic()

func _on_run_playbook_button_button_up():
	Scoring.reset_score()
	%machine.play(currentLevelPlaybook)
