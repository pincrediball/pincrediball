extends PanelContainer


func _ready():
	_load_current_stage()
	GameStore.level_changed.connect(_on_level_changed)


func _on_level_changed(_level: int):
	_load_current_stage()


func _load_current_stage():
	var stage = GameStore.get_current_stage()
	%LabelPlungeDelay.text = "Plunge: after %s seconds" % stage.plunge_delay
	%LabelLeftFlipperInterval.text = "Left flipper: every %s seconds" % stage.flipper_left_interval
	%LabelRightFlipperInterval.text = "Right flipper: every %s seconds" % stage.flipper_right_interval
	%LabelTiltTimings.text = "Tilt machine: never"
	%LabelMaxRunTime.text = "Time to drain ball: %s seconds" % stage.max_run_time
