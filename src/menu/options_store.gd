extends Node

const SAVE_OPTIONS_FILE_PATH = "user://options.tres"

var _options := Options.new()


func load_options():
	if not ResourceLoader.exists(SAVE_OPTIONS_FILE_PATH):
		return
	_options = load(SAVE_OPTIONS_FILE_PATH)
	Audio.set_mute_music(_options.is_music_enabled)
	Audio.set_mute_pinball_sfx(_options.is_sound_enabled)


func save_options():
	_options.is_music_enabled = Audio.has_muted_music()
	_options.is_sound_enabled = Audio.has_muted_pinball_sfx()
	ResourceSaver.save(_options, SAVE_OPTIONS_FILE_PATH)
