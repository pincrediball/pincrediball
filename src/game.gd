extends Control

signal menu_open_requested()

var playbooksByLevel = {
	1: preload("res://game/tutorial/playbook_level_001.tres"),
	2: preload("res://game/tutorial/playbook_level_001.tres"),
	3: preload("res://game/tutorial/playbook_level_001.tres"),
	4: preload("res://game/tutorial/playbook_level_001.tres"),
	5: preload("res://game/tutorial/playbook_level_001.tres"),
	6: preload("res://game/tutorial/playbook_level_001.tres"),
}

var currentLevelPlaybook: Resource

func _ready():
	currentLevelPlaybook = playbooksByLevel[GameStore.currentLevel]
	%Playbook.playbookResource = currentLevelPlaybook
	Audio.startGameMusic()

func _on_run_playbook_button_button_up():
	Audio.play_random_menu_button_sound()
	Scoring.reset_score()
	Scoring.set_enabled(true)
	%machine.play(currentLevelPlaybook)

func _on_stress_test_button_button_up():
	Audio.play_random_menu_button_sound()
	Scoring.reset_score()
	Scoring.set_enabled(false)
	%machine.stress_test(currentLevelPlaybook)

func _on_back_to_menu_button_pressed():
	Audio.play_random_menu_button_sound()
	menu_open_requested.emit()
