extends PanelContainer

func _ready():
	Scoring.score_changed.connect(_on_score_changed)

func _on_score_changed(_from: int, to: int):
	$VBoxContainer/MarginContainer2/ScoreLabel.text = "%s points" % to
