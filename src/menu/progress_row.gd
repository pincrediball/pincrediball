extends VBoxContainer

const MODULATE_EMPHASIS = Color(1, 1, 1, 1)
const MODULATE_NORMAL = Color(1, 1, 1, 0.25)

@export var progress_for_stage: ProgressForStage:
	get:
		return progress_for_stage
	set(value):
		progress_for_stage = value
		%LabelLevel.text = "Level %s" % value.level
		%LabelScore.text = "Personal best: %s" % Scoring.format_score(value.high_score)
		%LabelBronze.modulate = MODULATE_EMPHASIS if value.medals > 0 else MODULATE_NORMAL
		%LabelSilver.modulate = MODULATE_EMPHASIS if value.medals > 1 else MODULATE_NORMAL
		%LabelGold.modulate = MODULATE_EMPHASIS if value.medals > 2 else MODULATE_NORMAL

@export var is_unlocked: int:
	get:
		return is_unlocked
	set(value):
		is_unlocked = value
		if not is_unlocked:
			modulate = Color(1, 1, 1, 0.5)
			%LabelScore.text = "🔒"
		# Unicode aligns weird in Godo so we hack a little:
		%LabelScore.vertical_alignment = VERTICAL_ALIGNMENT_TOP if is_unlocked else VERTICAL_ALIGNMENT_CENTER
		

