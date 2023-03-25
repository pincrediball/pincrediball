extends PanelContainer

var medal_data


func _ready():
	Scoring.score_changed.connect(_on_score_changed)
	Scoring.scoring_mode_toggled.connect(_on_scoring_mode_toggled)

	medal_data = GameStore.get_current_medal_targets()
	GameStore.level_changed.connect(_on_level_changed)
	GameStore.high_score_changed.connect(_on_high_score_changed)
	_set_score(0)
	_set_high_score(0)


func _on_level_changed():
	medal_data = GameStore.get_current_medal_targets()


func _on_score_changed(_from: int, to: int):
	_set_score(to)


func _on_high_score_changed(to: int):
	_set_high_score(to)


func _on_scoring_mode_toggled(enabled: bool):
	%DisabledOverlay.visible = not enabled


func _set_score(to: int):
	%ScoreLabel.text = "%s %s" % [_format_medal(to), Scoring.format_score(to)]


func _set_high_score(to: int):
	%HighScoreLabel.text = "%s %s" % [_format_medal(to), Scoring.format_score(to)]


func _format_medal(score: int) -> String:
	if score >= medal_data.gold:
		return "🥇"
	elif score >= medal_data.silver:
		return "🥈"
	elif score >= medal_data.bronze:
		return "🥉"
	else:
		return ""
