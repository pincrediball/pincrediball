extends PanelContainer


func _ready():
	_load_current_playbook()
	GameStore.level_changed.connect(_load_current_playbook)


func _load_current_playbook():
	var data = GameStore.get_current_playbook()
	%LabelPlungeDelay.text = "Plunge: after %s seconds" % data.plunge_delay
	%LabelLeftFlipperInterval.text = "Left flipper: every %s seconds" % data.flipper_left_interval
	%LabelRightFlipperInterval.text = "Right flipper: every %s seconds" % data.flipper_right_interval
	%LabelTiltTimings.text = "Tilt machine: never"
	%LabelMaxRunTime.text = "Time to drain ball: %s seconds" % data.max_run_time
