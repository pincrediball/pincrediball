extends Control

func _on_animation_player_animation_finished(_anim_name):
	queue_free()
