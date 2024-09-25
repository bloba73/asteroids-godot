extends Node2D

@onready var lasers = $Lasers
@onready var player = $Player
@onready var asteroids = $Asteroids

var asteroid_scene = preload("res://scenes/enemy/asteroid.tscn")

var score := 0

func _ready():
	score = 0
	player.connect("laser_shot", _on_player_laser_shots)
	
	for asteroid in asteroids.get_children():
		asteroid.connect("exploded", _on_asteroid_exploded)

func _process(delta):
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()

func _on_player_laser_shots(laser):
	lasers.add_child(laser)

func _on_asteroid_exploded(pos, size, points):
	score += points
	print(score)
	for i in range(2):
		match size:
			Asteroid.AsteroidSize.LARGE:
				spawn_asteriod(pos, Asteroid.AsteroidSize.MEDIUM)
			Asteroid.AsteroidSize.MEDIUM:
				spawn_asteriod(pos, Asteroid.AsteroidSize.SMALL)
			Asteroid.AsteroidSize.SMALL:
				pass

func spawn_asteriod(pos, size):
	var a = asteroid_scene.instantiate()
	a.global_position = pos
	a.size = size
	a.connect("exploded", _on_asteroid_exploded)
	asteroids.call_deferred("add_child", a)
