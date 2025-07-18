extends Node2D

@onready var lasers = $Lasers
@onready var player = $Player
@onready var asteroids = $Asteroids
@onready var game_over_scene = $UI/GameOverMenu
@onready var hud = $UI/HUD
@onready var player_spawn_pos = $PlayerSpawnPos
@onready var player_spawn_area = $PlayerSpawnPos/PlayerSpawnArea

var asteroid_scene = preload("res://scenes/enemy/asteroid.tscn")

var score: int : set = set_score
var lives: int:
	set(value):
		lives = value
		hud.init_lives(lives)

func set_score(value: int) -> void:
	score = value
	hud.update_score(score)

func _ready():
	game_over_scene.visible = false
	lives = 3
	set_score(0)
	player.connect("laser_shot", _on_player_laser_shots)
	player.connect("died", _on_player_died)
	
	for asteroid in asteroids.get_children():
		asteroid.connect("exploded", _on_asteroid_exploded)

func _on_player_laser_shots(laser):
	$LaserSound.play()
	lasers.add_child(laser)

func _on_asteroid_exploded(pos, size, points):
	$AsteroidHitSound.play()
	score += points
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

func _on_player_died():
	$PlayerDieSound.play()
	lives -= 1
	player.global_position = player_spawn_pos.global_position
	if lives <= 0:
		await get_tree().create_timer(1).timeout
		game_over_scene.visible = true
	else:
		await get_tree().create_timer(1).timeout
		while !player_spawn_area.is_empty:
			await get_tree().create_timer(0.1).timeout
		player.respawn(player_spawn_pos.global_position)
