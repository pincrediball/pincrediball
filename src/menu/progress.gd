extends Control

const STAGES := [
	"Tutorial",
	"Stage 1 (to be released!)",
	"Stage 2 (to be released!)",
	"Stage 3 (to be released!)",
]

const ProgressRow = preload("res://menu/progress_row.tscn")


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
