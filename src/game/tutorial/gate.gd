extends StaticBody2D

const BASE_SCORE = 100
const sounds = [
	preload("res://sound/rollover-001.wav"),
	preload("res://sound/rollover-002.wav"),
	preload("res://sound/rollover-003.wav"),
	preload("res://sound/rollover-004.wav"),
]

signal was_activated()
var isActivated: bool = false:
	get:
		return isActivated
	set(value):
		if value != isActivated:
			$Sprite2DRollOver.modulate = Color(1, 1, 1, 1) if value else Color(0.16, 0.16, 0.16, 1)
			isActivated = value
			if value:
				was_activated.emit()

func _on_roll_over_area_2d_body_exited(body):
	if not isActivated and body.is_in_group("isBall") && (body as RigidBody2D).linear_velocity.y > 0:
		$AudioStreamPlayer.stream = sounds[randi() % len(sounds)]
		$AudioStreamPlayer.play()
		isActivated = true
		Scoring.add_score(BASE_SCORE)

func resetPinballComponent():
	isActivated = false
