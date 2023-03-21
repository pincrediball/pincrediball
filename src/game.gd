extends Control

var playbooksByLevel = {
	1: preload("res://game/tutorial/playbook_level_001.tres"),
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
	%machine.play(currentLevelPlaybook)

func _on_music_check_button_toggled(button_pressed):
	Audio.set_mute_music(not button_pressed)

func _on_sound_check_button_toggled(button_pressed):
	Audio.set_mute_pinball_sfx(not button_pressed)
