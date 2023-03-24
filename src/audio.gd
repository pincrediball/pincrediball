extends Node

const tracks = [
	preload("res://music/one-cool-minute.mp3"),
	preload("res://music/waiting-tttt.mp3"),
	preload("res://music/amazing-grace.mp3"),
]

const menu_button_sound := preload("res://sound/menu-button-001.wav")
const credits_track = preload("res://music/dear-mr-super-computer.mp3")

const music_volume_default = -5.0
const music_volume_suppressed = -18.0

const bus_name_music = "Music"
const bus_name_pinball_sfx = "PinballSFX"

var bus_id_music := AudioServer.get_bus_index(bus_name_music)
var bus_id_pinball_sfx := AudioServer.get_bus_index(bus_name_pinball_sfx)
var trackIndex = randi() % tracks.size()

func startGameMusic():
	$Music.stream = tracks[trackIndex]
	$Music.play()

func startCreditsMusic():
	set_suppressed_music(false)
	$Music.stream = credits_track
	$Music.play()

func set_credits_music_speed(speed: float):
	$Music.pitch_scale = speed

func _on_game_music_finished():
	trackIndex = (trackIndex + 1) % tracks.size()
	$Music.stream = tracks[trackIndex]
	$Music.play()
	
func set_suppressed_music(is_suppressed):
	$Music.volume_db = music_volume_suppressed if is_suppressed else music_volume_default
	
func set_mute_music(is_muted):
	AudioServer.set_bus_mute(bus_id_music, is_muted)

func has_muted_music():
	return AudioServer.is_bus_mute(bus_id_music)

func set_mute_pinball_sfx(is_muted):
	AudioServer.set_bus_mute(bus_id_pinball_sfx, is_muted)

func has_muted_pinball_sfx():
	return AudioServer.is_bus_mute(bus_id_pinball_sfx)

func play_random_menu_button_sound():
	var sound = menu_button_sound
	$GenericSFX.stream = sound
	$GenericSFX.play()
	
