extends Node

enum STEAM_INIT_CODES {
	SUCCESS = 1,
	FAILED = 2,
	STEAM_NOT_RUNNING = 20,
	INVALID_APP = 79,
}

var _is_steam_available := false

func _ready():
	_initialize_Steam()
	GameStore.high_score_changed.connect(_on_high_score_changed)
	GameStore.number_of_medals_changed.connect(_on_number_of_medals_changed)


func _process(_delta: float) -> void:
	Steam.run_callbacks()


func _initialize_Steam():
	var steam_init_result: Dictionary = Steam.steamInit(false)
	if steam_init_result["status"] == STEAM_INIT_CODES.SUCCESS:
		_is_steam_available = true


func _on_high_score_changed(to: int):
	if _is_steam_available:
		var machine_key = GameStore.get_current_machine().key
		var level = GameStore.get_current_level()
		var stat_api_name = "%s_score_level_%03d" % [machine_key, level]
		Steam.setStatInt(stat_api_name, to)
		Steam.storeStats()


func _on_number_of_medals_changed(medal_counts: Dictionary):
	if _is_steam_available:
		var machine_key = GameStore.get_current_machine().key
		for key in medal_counts:
			var stat_api_name = "%s_medals_%s" % [machine_key, key]
			Steam.setStatInt(stat_api_name, medal_counts[key])
		Steam.storeStats()

