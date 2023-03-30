extends PanelContainer

const HIGH_SCORE_SOUND = preload("res://sound/high-score-achieved-001.mp3")
const TIMER_SOUND_NORMAL = preload("res://sound/timer-tick-001.wav")
const TIMER_SOUND_PRESSURE = preload("res://sound/timer-tick-002.wav")
const TIMER_SOUND_ALARM = preload("res://sound/timer-alarm-001.mp3")

const MEDAL_TEXTURES = {
	"gold": preload("res://art/game/medal-gold.png"),
	"silver": preload("res://art/game/medal-silver.png"),
	"bronze": preload("res://art/game/medal-bronze.png"),
	"none": preload("res://art/game/medal-bronze.png"),
}

const VOLUME_DB_NORMAL := 0.0
const VOLUME_DB_ALARM := -9.0

var _stage
var _time_integer: int

func _ready():
	_stage = GameStore.get_current_stage()
	
	Scoring.score_changed.connect(_on_score_changed)
	Scoring.scoring_mode_toggled.connect(_on_scoring_mode_toggled)
	Scoring.time_left_changed.connect(_on_time_left_changed)
	Scoring.time_ran_out.connect(_on_time_ran_out)
	
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
	_set_time_ran_out_mode_to(false)


func _on_score_changed(_from: int, to: int):
	_set_score(to)


func _on_high_score_changed(to: int):
	_set_high_score(to)
	get_tree().create_timer(0.5).timeout.connect(_celebrate_high_score)


func _on_scoring_mode_toggled(enabled: bool):
	%DisabledOverlay.visible = not enabled


func _on_time_left_changed(to: float, pressure):
	var truncated_time_left = int(to)
	if truncated_time_left < _time_integer:
		match pressure:
			Scoring.TimePressure.HIGH:
				%AudioStreamPlayerTicker.volume_db = VOLUME_DB_ALARM
				%AudioStreamPlayerTicker.stream = TIMER_SOUND_ALARM
			Scoring.TimePressure.MEDIUM:
				%AudioStreamPlayerTicker.volume_db = VOLUME_DB_NORMAL
				%AudioStreamPlayerTicker.stream = TIMER_SOUND_PRESSURE
			_:
				%AudioStreamPlayerTicker.volume_db = VOLUME_DB_NORMAL
				%AudioStreamPlayerTicker.stream = TIMER_SOUND_NORMAL
		%AudioStreamPlayerTicker.play()
	_time_integer = truncated_time_left
	_set_time_left(to)


func _on_time_ran_out():
	_set_time_ran_out_mode_to(true)


func _set_time_ran_out_mode_to(is_error: bool):
	%TimeLeftLabel.modulate = Color(1.0, 0.2, 0.2, 0.75) if is_error else Color(1, 1, 1, 1)
	%ScoreLabel.modulate = Color(1.0, 0.2, 0.2, 0.75) if is_error else Color(1, 1, 1, 1)


func _set_time_left(to: float):
	%TimeLeftLabel.text = "Time to drain: %.3fs" % to
	%ProgressBar.value = to / _stage.max_run_time * 100.0


func _set_score(to: int):
	_set_time_ran_out_mode_to(false)
	var key = _medal_key(to)
	%ScoreLabel.text = "%s" % Scoring.format_score(to)
	%ScoreMedal.texture = MEDAL_TEXTURES[key]
	%ScoreMedal.modulate = Color(1,1,1,0.25) if key == "none" else Color(1,1,1,1)


func _set_high_score(to: int):
	var key = _medal_key(to)
	%HighScoreLabel.text = "%s" % Scoring.format_score(to)
	%HighScoreMedal.texture = MEDAL_TEXTURES[key]
	%HighScoreMedal.modulate = Color(1,1,1,0.25) if key == "none" else Color(1,1,1,1)


func _celebrate_high_score():
	$AudioStreamPlayer.stream = HIGH_SCORE_SOUND
	$AudioStreamPlayer.play()
	%CelebrationParticles.restart()

func _medal_key(score: int) -> String:
	if score >= _stage.gold:
		return "gold"
	elif score >= _stage.silver:
		return "silver"
	elif score >= _stage.bronze:
		return "bronze"
	else:
		return "none"
