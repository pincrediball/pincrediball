extends VBoxContainer

const MODULATE_EMPHASIS = Color(1, 1, 1, 1)
const MODULATE_NORMAL = Color(1, 1, 1, 0.25)

@export var progress_for_level: ProgressForLevel:
	get:
		return progress_for_level
	set(value):
		progress_for_level = value
		%LabelLevel.text = "Level %s" % value.level
		%LabelScore.text = "Personal best: %s" % Scoring.format_score(value.high_score)
		%LabelBronze.modulate = MODULATE_EMPHASIS if value.medals > 0 else MODULATE_NORMAL
		%LabelSilver.modulate = MODULATE_EMPHASIS if value.medals > 1 else MODULATE_NORMAL
		%LabelGold.modulate = MODULATE_EMPHASIS if value.medals > 2 else MODULATE_NORMAL
