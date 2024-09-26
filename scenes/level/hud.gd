extends Control

@onready var score_label = $Score

func update_score(new_score: int) -> void:
	score_label.text = "SCORE: " + str(new_score)

var uilife_scene = preload("res://scenes/level/player_live.tscn")

@onready var lives = $Lives

func init_lives(amount):
		for ul in lives.get_children():
			ul.queue_free()
		for i in amount:
			var ul = uilife_scene.instantiate()
			lives.add_child(ul)
