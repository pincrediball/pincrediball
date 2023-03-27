extends Control

const STAGES := [
	"Tutorial",
	"Newbie Stage",
	"Normie Stage",
	"Nasty Stage",
	"Nightmare Stage"
]

const ProgressRow = preload("res://menu/progress_row.tscn")

var _stage_shown_index := 0


func _on_back_button_pressed():
	Audio.play_menu_button_sound_back()
	self.hide()


func _on_visibility_changed():
	var progress = GameStore.get_progress()

	for child in %ProgressionRows.get_children():
		child.queue_free()

	if visible and progress:
		for progress_for_level in progress.levels:
			var row = ProgressRow.instantiate()
			row.progress_for_level = progress_for_level
			%ProgressionRows.add_child(row)
	
	# Hardcoded while we still only have 1 specific stage
	%ButtonPreviousStage.modulate = Color(1,1,1,0)
	_switch_to_stage(0)


func _switch_to_stage(index):
	if index != _stage_shown_index:
		$StageSwapAnimationPlayer.play("progression_rows_fade_out")
		await $StageSwapAnimationPlayer.animation_finished
		%StageLabel.text = STAGES[index]
		
		%ButtonPreviousStage.disabled = index == 0
		%ButtonPreviousStage.modulate = Color(1,1,1,0) if index == 0 else Color(1,1,1,1)
		
		%ButtonNextStage.disabled = index == (len(STAGES) - 1)
		%ButtonNextStage.modulate = Color(1,1,1,0) if index == (len(STAGES) - 1) else Color(1,1,1,1)
		
		%ProgressionRows.visible = index == 0
		%StageEmptyContainer.visible = index != 0
		$StageSwapAnimationPlayer.play_backwards("progression_rows_fade_out")
		_stage_shown_index = index


func _on_button_next_stage_pressed():
	Audio.play_menu_button_sound_next()
	if _stage_shown_index < len(STAGES) - 1:
		_switch_to_stage(_stage_shown_index + 1)


func _on_button_previous_stage_pressed():
	Audio.play_menu_button_sound_back()
	if _stage_shown_index > 0:
		_switch_to_stage(_stage_shown_index - 1)
