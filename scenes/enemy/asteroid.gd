class_name Asteroid extends Area2D

signal exploded(pos, size, points)

var movment_vector := Vector2(0, -1)
var speed := 50

enum AsteroidSize{LARGE, MEDIUM, SMALL}
@export var size := AsteroidSize.LARGE

@onready var sprite = $Sprite2D
@onready var cshape = $CollisionShape2D

var points: int:
	get:
		match size:
			AsteroidSize.LARGE:
				return 50
			AsteroidSize.MEDIUM:
				return 75
			AsteroidSize.SMALL:
				return 100
			_:
				return 0

func _ready():
	rotation = randf_range(0, 2*PI)
	
	match size:
		AsteroidSize.LARGE:
			speed = randf_range(50, 100)
			sprite.texture = preload("res://assets/asteroidBig.png")
			cshape.set_deferred("shape", preload("res://resources/asteroid_cshape_large.tres"))
		AsteroidSize.MEDIUM:
			speed = randf_range(80, 130)
			sprite.texture = preload("res://assets/AsteroidMedium.png")
			cshape.set_deferred("shape", preload("res://resources/asteroid_cshape_medium.tres"))
		AsteroidSize.SMALL:
			speed = randf_range(95, 145)
			sprite.texture = preload("res://assets/asteroidSmall.png")
			cshape.set_deferred("shape", preload("res://resources/asteroid_cshape_small.tres"))

func _physics_process(delta):
	global_position += movment_vector.rotated(rotation) * speed * delta
	
	var shape_size = cshape.shape.radius
	var screen_size = get_viewport_rect().size
	if global_position.y+shape_size < 0:
		global_position.y = screen_size.y+shape_size
	elif global_position.y-shape_size > screen_size.y:
		global_position.y = -shape_size
		
	if global_position.x+shape_size < 0:
		global_position.x = screen_size.x+shape_size
	elif global_position.x-shape_size > screen_size.x:
		global_position.x = -shape_size

func explode():
	emit_signal("exploded", global_position, size, points)
	queue_free()
