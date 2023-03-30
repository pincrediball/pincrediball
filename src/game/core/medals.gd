extends PanelContainer


func _ready():
	_load_current_stage()
	GameStore.level_changed.connect(_on_level_changed)


func _on_level_changed(_level: int):
	_load_current_stage()
	

func _load_current_stage():
	var stage = GameStore.get_current_stage()
	%LabelGold.text =   "%s points" % Scoring.format_score(stage.gold, 6)
	%LabelSilver.text = "%s points" % Scoring.format_score(stage.silver, 6)
	%LabelBronze.text = "%s points" % Scoring.format_score(stage.bronze, 6)
