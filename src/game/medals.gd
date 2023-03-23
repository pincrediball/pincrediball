extends PanelContainer

func _ready():
	load_current_playbook()
	GameStore.level_changed.connect(load_current_playbook)
	
func load_current_playbook():
	var data = GameStore.get_current_medal_targets()
	%LabelGold.text = "🥇 %s points" % data.gold
	%LabelSilver.text = "🥈 %s points" % data.silver
	%LabelBronze.text = "🥉 %s points" % data.bronze
