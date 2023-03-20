extends PanelContainer

@export var playbookResource: PlaybookResource:
	get:
		return playbookResource
	set(value):
		playbookResource = value
		if value:
			%LabelPlungeDelay.text = "Plunge: after %s seconds" % value.plunge_delay
			%LabelLeftFlipperInterval.text = "Left flipper: every %s seconds" % value.flipper_left_interval
			%LabelRightFlipperInterval.text = "Right flipper: every %s seconds" % value.flipper_right_interval
			%LabelTiltTimings.text = "Tilt machine: never"
