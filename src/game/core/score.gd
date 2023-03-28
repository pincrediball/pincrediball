extends PanelContainer

const HIGH_SCORE_SOUND = preload("res://sound/high-score-achieved-001.mp3")
const TIMER_SOUND_NORMAL = preload("res://sound/timer-tick-001.wav")
const TIMER_SOUND_PRESSURE = preload("res://sound/timer-tick-002.wav")
const TIMER_SOUND_ALARM = preload("res://sound/timer-alarm-001.mp3")

const VOLUME_DB_NORMAL := 0.0
const VOLUME_DB_ALARM := -9.0

var _stage
var _time_rounded: int

func _ready():
	_stage = GameStore.get_current_stage()
	
	Scoring.score_changed.connect(_on_score_changed)
	Scoring.scoring_mode_toggled.connect(_on_scoring_mode_toggled)
	Scoring.time_left_changed.connect(_on_time_left_changed)
	
	GameStore.level_changed.connect(_on_level_changed)
	GameStore.high_score_changed.connect(_on_high_score_changed)
	
	_set_score(0)
	_set_high_score(GameStore.get_current_stage_high_score())
	_set_time_left(_stage.max_run_time)


func _on_level_changed(_level: int):
	_stage = GameStore.get_current_stage()
	_set_score(0)
	_set_high_score(GameStore.get_current_stage_high_score())
	_set_time_left(_stage.max_run_time)


func _on_score_changed(_from: int, to: int):
	_set_score(to)


func _on_high_score_changed(to: int):
	_set_high_score(to)
	get_tree().create_timer(0.5).timeout.connect(_celebrate_high_score)


func _on_scoring_mode_toggled(enabled: bool):
	%DisabledOverlay.visible = not enabled


func _on_time_left_changed(to: float):
	var rounded = int(to)
	if rounded != _time_rounded:
		if rounded >= 5:
			%AudioStreamPlayerTicker.volume_db = VOLUME_DB_NORMAL
			%AudioStreamPlayerTicker.stream = TIMER_SOUND_NORMAL
		elif rounded >= 2:
			%AudioStreamPlayerTicker.volume_db = VOLUME_DB_NORMAL
			%AudioStreamPlayerTicker.stream = TIMER_SOUND_PRESSURE
		else:
			%AudioStreamPlayerTicker.volume_db = VOLUME_DB_ALARM
			%AudioStreamPlayerTicker.stream = TIMER_SOUND_ALARM
			
		%AudioStreamPlayerTicker.play()
	_time_rounded = rounded
	_set_time_left(to)


func _set_time_left(to: float):
	%TimeLeftLabel.text = "%.3fs" % to
	%ProgressBar.value = to / _stage.max_run_time * 100.0


func _set_score(to: int):
	%ScoreLabel.text = "%s %s" % [_format_medal(to), Scoring.format_score(to)]


func _set_high_score(to: int):
	%HighScoreLabel.text = "%s%s" % [_format_medal(to), Scoring.format_score(to)]


func _celebrate_high_score():
	$AudioStreamPlayer.stream = HIGH_SCORE_SOUND
	$AudioStreamPlayer.play()
	%CelebrationParticles.restart()


func _format_medal(score: int) -> String:
	if score >= _stage.gold:
		return "🥇 "
	elif score >= _stage.silver:
		return "🥈 "
	elif score >= _stage.bronze:
		return "🥉 "
	else:
		return ""
