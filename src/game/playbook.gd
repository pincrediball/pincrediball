extends PanelContainer

func _ready():
	var data = GameStore.get_current_playbook()
	%LabelPlungeDelay.text = "Plunge: after %s seconds" % data.plunge_delay
	%LabelLeftFlipperInterval.text = "Left flipper: every %s seconds" % data.flipper_left_interval
	%LabelRightFlipperInterval.text = "Right flipper: every %s seconds" % data.flipper_right_interval
	%LabelTiltTimings.text = "Tilt machine: never"
