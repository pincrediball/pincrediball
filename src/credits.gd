extends Control

var is_running_fast := false

func close():
	Audio.startGameMusic()
	queue_free()

func _ready():
	Audio.startCreditsMusic()

func _input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"):
		close()
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed() and not is_running_fast:
			is_running_fast = true
			$AnimationPlayer.speed_scale = 5.0
			Audio.set_credits_music_speed(5.0)
		elif is_running_fast and Input.is_action_just_released("action_left_mouse_button"):
			is_running_fast = false
			$AnimationPlayer.speed_scale = 1.0
			Audio.set_credits_music_speed(1.0)

func _on_texture_button_pressed():
	close()

func _on_animation_player_animation_finished(anim_name):
	close()
