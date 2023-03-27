extends PanelContainer


func _ready():
	_load_current_playbook()
	GameStore.level_changed.connect(_on_level_changed)


func _on_level_changed(_level: int):
	_load_current_playbook()
	

func _load_current_playbook():
	var data = GameStore.get_current_medal_targets()
	%LabelGold.text = "🥇 %s points" % Scoring.format_score(data.gold)
	%LabelSilver.text = "🥈 %s points" % Scoring.format_score(data.silver)
	%LabelBronze.text = "🥉 %s points" % Scoring.format_score(data.bronze)
