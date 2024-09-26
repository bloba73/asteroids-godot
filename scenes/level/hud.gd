extends Control

@onready var score_label = $Score

func update_score(new_score: int) -> void:
	score_label.text = "SCORE: " + str(new_score)
