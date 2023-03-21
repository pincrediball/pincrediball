extends Control

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
	%MusicCheckButton.set_pressed_no_signal(not Audio.has_muted_music())
	%SoundCheckButton.set_pressed_no_signal(not Audio.has_muted_pinball_sfx())

func _on_run_playbook_button_button_up():
	Scoring.reset_score()
	Scoring.set_enabled(true)
	%machine.play(currentLevelPlaybook)

func _on_stress_test_button_button_up():
	Scoring.reset_score()
	Scoring.set_enabled(false)
	%machine.stress_test(currentLevelPlaybook)

func _on_music_check_button_toggled(button_pressed):
	Audio.set_mute_music(not button_pressed)

func _on_sound_check_button_toggled(button_pressed):
	Audio.set_mute_pinball_sfx(not button_pressed)

