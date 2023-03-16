extends Control

var playbooksByLevel = {
	1: preload("res://game/tutorial/playbook_level_001.tres"),
}

var currentLevel: int = 1

func _on_button_button_up():
	Scoring.reset_score()
	var levelPlaybook = playbooksByLevel[currentLevel]
	$machine.play(levelPlaybook)
