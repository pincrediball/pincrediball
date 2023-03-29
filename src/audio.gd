extends Node

static func play_random_sound_with(audio_stream_player: AudioStreamPlayer, sounds: Array[Resource]):
	audio_stream_player.stream = sounds[randi() % len(sounds)]
	audio_stream_player.play()

const MUSIC_TRACKS_GAME: Array[Resource] = [
	preload("res://music/one-cool-minute.mp3"),
	preload("res://music/waiting-tttt.mp3"),
	preload("res://music/amazing-grace.mp3"),
]

const MENU_BUTTON_SOUND_NEXT := preload("res://sound/menu-button-001.wav")
const MENU_BUTTON_SOUND_BACK := preload("res://sound/menu-button-002.wav")
const MUSIC_TRACK_CREDITS = preload("res://music/dear-mr-super-computer.mp3")
const MUSIC_TRACK_VICTORY = preload("res://music/b-3.mp3")

const music_volume_default := -5.0
const music_volume_suppressed := -18.0

const BUS_NAME_MUSIC := "Music"
const BUS_NAME_PINBALL_SFX := "PinballSFX"

var bus_id_music := AudioServer.get_bus_index(BUS_NAME_MUSIC)
var bus_id_pinball_sfx := AudioServer.get_bus_index(BUS_NAME_PINBALL_SFX)
var music_track_index: int = randi() % MUSIC_TRACKS_GAME.size()


func start_music_for_game():
	$Music.stream = MUSIC_TRACKS_GAME[music_track_index]
	$Music.play()


func start_music_for_credits():
	set_suppressed_music(false)
	$Music.stream = MUSIC_TRACK_CREDITS
	$Music.play()


func start_music_for_victory():
	set_suppressed_music(false)
	$Music.stream = MUSIC_TRACK_VICTORY
	$Music.play()


func set_credits_music_speed(speed: float):
	$Music.pitch_scale = speed


func _on_game_music_finished():
	music_track_index += 1
	music_track_index %= len(MUSIC_TRACKS_GAME)
	# This code might also go back from Credits/Victory music to default music
	$Music.stream = MUSIC_TRACKS_GAME[music_track_index]
	$Music.play()


func set_suppressed_music(is_suppressed: bool):
	$Music.volume_db = music_volume_suppressed if is_suppressed else music_volume_default


func set_mute_music(is_muted: bool):
	AudioServer.set_bus_mute(bus_id_music, is_muted)


func has_muted_music():
	return AudioServer.is_bus_mute(bus_id_music)


func set_mute_pinball_sfx(is_muted: bool):
	AudioServer.set_bus_mute(bus_id_pinball_sfx, is_muted)


func has_muted_pinball_sfx():
	return AudioServer.is_bus_mute(bus_id_pinball_sfx)


func play_menu_button_sound_next():
	$GenericSFX.stream = MENU_BUTTON_SOUND_NEXT
	$GenericSFX.play()


func play_menu_button_sound_back():
	$GenericSFX.stream = MENU_BUTTON_SOUND_BACK
	$GenericSFX.play()
	
