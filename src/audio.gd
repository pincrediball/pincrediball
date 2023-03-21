extends AudioStreamPlayer

const tracks = [
	preload("res://music/one-cool-minute.mp3"),
	preload("res://music/waiting-tttt.mp3"),
	preload("res://music/amazing-grace.mp3"),
]

const music_volume_default = -5.0
const music_volume_suppressed = -18.0

var bus_id_music := AudioServer.get_bus_index("Music")
var bus_id_pinball_sfx := AudioServer.get_bus_index("PinballSFX")
var trackIndex = randi() % tracks.size()

func startGameMusic():
	Audio.stream = tracks[trackIndex]
	Audio.play()

func _on_finished():
	trackIndex = (trackIndex + 1) % tracks.size()
	Audio.stream = tracks[trackIndex]
	Audio.play()
	
func set_suppressed_music(is_suppressed):
	Audio.volume_db = music_volume_suppressed if is_suppressed else music_volume_default
	
func set_mute_music(is_muted):
	AudioServer.set_bus_mute(bus_id_music, is_muted)

func has_muted_music():
	return AudioServer.is_bus_mute(bus_id_music)

func set_mute_pinball_sfx(is_muted):
	AudioServer.set_bus_mute(bus_id_pinball_sfx, is_muted)

func has_muted_pinball_sfx():
	return AudioServer.is_bus_mute(bus_id_pinball_sfx)

