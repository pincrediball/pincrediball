extends Control

const MACHINE_TITLES := [
	"Tutorial Machine",
	"Newbie Machine",
	"Normie Machine",
	"Nasty Machine",
	"Nightmare Machine"
]

const ProgressRow = preload("res://menu/progress_row.tscn")

var _machine_shown_index := 0


func _input(event: InputEvent):
	if event.is_action_pressed("ui_cancel") and self.visible:
		self.hide()


func _on_back_button_pressed():
	Audio.play_menu_button_sound_back()
	self.hide()


func _on_visibility_changed():
	var progress = GameStore.get_progress()
	var max_unlocked_level = GameStore.get_max_level_for_stage("tutorial")

	for child in %ProgressionRows.get_children():
		child.queue_free()

	if visible and progress:
		for progress_for_stage in progress.stages:
			var row = ProgressRow.instantiate()
			row.progress_for_stage = progress_for_stage
			row.is_unlocked = progress_for_stage.level <= max_unlocked_level
			%ProgressionRows.add_child(row)
	
	# Hardcoded while we still only have 1 specific machine
	%ButtonPreviousStage.modulate = Color(1,1,1,0)
	_switch_to_machine(0)


func _switch_to_machine(index):
	if index != _machine_shown_index:
		$StageSwapAnimationPlayer.play("progression_rows_fade_out")
		await $StageSwapAnimationPlayer.animation_finished
		%StageLabel.text = MACHINE_TITLES[index]
		
		%ButtonPreviousStage.disabled = index == 0
		%ButtonPreviousStage.modulate = Color(1,1,1,0) if index == 0 else Color(1,1,1,1)
		
		%ButtonNextStage.disabled = index == (len(MACHINE_TITLES) - 1)
		%ButtonNextStage.modulate = Color(1,1,1,0) if index == (len(MACHINE_TITLES) - 1) else Color(1,1,1,1)
		
		%ProgressionRows.visible = index == 0
		%StageEmptyContainer.visible = index != 0
		$StageSwapAnimationPlayer.play_backwards("progression_rows_fade_out")
		_machine_shown_index = index


func _on_button_next_stage_pressed():
	Audio.play_menu_button_sound_next()
	if _machine_shown_index < len(MACHINE_TITLES) - 1:
		_switch_to_machine(_machine_shown_index + 1)


func _on_button_previous_stage_pressed():
	Audio.play_menu_button_sound_back()
	if _machine_shown_index > 0:
		_switch_to_machine(_machine_shown_index - 1)
