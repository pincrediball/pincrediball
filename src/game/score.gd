extends PanelContainer

var medal_data

func _ready():
	Scoring.score_changed.connect(_on_score_changed)
	Scoring.toggled_enabled.connect(_on_toggled_enabled)

	medal_data = GameStore.get_current_medal_targets()
	GameStore.level_changed.connect(_on_level_changed)
	set_score(0)

func _on_level_changed():
	medal_data = GameStore.get_current_medal_targets()

func _on_score_changed(_from: int, to: int):
	set_score(to)
	
func _on_toggled_enabled(enabled: bool):
	%DisabledOverlay.visible = not enabled

func set_score(to: int):
	%ScoreLabel.text = "%s %s points" % [format_medal(to), format_score(to)]

func format_medal(score: int):
	if score >= medal_data.gold:
		return "🥇"
	elif score >= medal_data.silver:
		return "🥈"
	elif score >= medal_data.bronze:
		return "🥉"
	else:
		return " "

# Whelp! GDScript doesn't have much formatting, does it? Apparently we 
# have to write this stuff ourselves? Also no StringBuilder or similar
# so this'll have to do... 
# Adapted from https://godotengine.org/qa/18559/how-to-add-commas-to-an-integer-or-float-in-gdscript
func format_score(score: int):
	var result = "%s" % score
	var i : int = result.length() - 3
	while i > 0:
		result = result.insert(i, ",")
		i = i - 3
	return result
