extends PanelContainer

const HIGH_SCORE_SOUND = preload("res://sound/high-score-achieved-001.mp3")

var _medal_data
var _last_known_high_score := 0

func _ready():
	Scoring.score_changed.connect(_on_score_changed)
	Scoring.scoring_mode_toggled.connect(_on_scoring_mode_toggled)

	_medal_data = GameStore.get_current_medal_targets()
	GameStore.level_changed.connect(_on_level_changed)
	GameStore.high_score_changed.connect(_on_high_score_changed)
	_set_score(0)
	_set_high_score(0)


func _on_level_changed():
	_medal_data = GameStore.get_current_medal_targets()


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
	if to > _last_known_high_score:
		get_tree().create_timer(0.5).timeout.connect(_celebrate_high_score)
	_last_known_high_score = to


func _celebrate_high_score():
	$AudioStreamPlayer.stream = HIGH_SCORE_SOUND
	$AudioStreamPlayer.play()
	%CelebrationParticles.restart()


func _format_medal(score: int) -> String:
	if score >= _medal_data.gold:
		return "🥇"
	elif score >= _medal_data.silver:
		return "🥈"
	elif score >= _medal_data.bronze:
		return "🥉"
	else:
		return ""
