extends PanelContainer

func _ready():
	Scoring.score_changed.connect(_on_score_changed)
	Scoring.toggled_enabled.connect(_on_toggled_enabled)

func _on_score_changed(_from: int, to: int):
	%ScoreLabel.text = "%s points" % format_score(to)
	
func _on_toggled_enabled(enabled: bool):
	%DisabledOverlay.visible = not enabled
	
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
