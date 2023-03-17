extends AudioStreamPlayer

const tracks = [
	preload("res://music/one-cool-minute.mp3"),
	preload("res://music/waiting-tttt.mp3"),
	preload("res://music/amazing-grace.mp3"),
]

var trackIndex = randi() % tracks.size()

var volumeDefault = -5.0
var volumeSuppressed = -18.0

func startGameMusic():
	Music.stream = tracks[trackIndex]
	Music.play()

func _on_finished():
	trackIndex = (trackIndex + 1) % tracks.size()
	Music.stream = tracks[trackIndex]
	Music.play()
	
func suppress():
	Music.volume_db = volumeSuppressed
	
func unsuppress():
	Music.volume_db = volumeDefault
