class_name Player extends CharacterBody2D

signal laser_shot(laser)
signal died

@export var acceleration := 10.0

@onready var anim = get_node("AnimatedSprite2D")
@onready var muzzle = $Muzzle
@onready var sprite = $AnimatedSprite2D
@onready var cshape = $CollisionPolygon2D

var laser_scene = preload("res://Player/laser.tscn")
var shoot_cooldown = false

var alive := true

func _process(delta):
	if !alive: return
	
	if Input.is_action_pressed("shootbutton"):
		if !shoot_cooldown:
			shoot_cooldown = true
			shoot_laser()
			await get_tree().create_timer(0.4).timeout
			shoot_cooldown = false

func _physics_process(delta):
	if !alive: return
	
	var input_vector = Vector2(0, Input.get_axis("move_forward", "move_backward"))
	
	velocity += input_vector.rotated(rotation) * acceleration
	velocity = velocity.limit_length(500.0)
	
	if input_vector.y == 0:
		velocity = velocity.move_toward(Vector2.ZERO, 3)
	
	if Input.is_action_pressed("rotate_left"):
		rotate(deg_to_rad(-250.0*delta))
	if Input.is_action_pressed("rotate_right"):
		rotate(deg_to_rad(250.0*delta))
	
	move_and_slide()
	
	var screen_size = get_viewport_rect().size
	if global_position.y < 0:
		global_position.y = screen_size.y
	elif global_position.y > screen_size.y:
		global_position.y = 0
		
	if global_position.x < 0:
		global_position.x = screen_size.x
	elif global_position.x > screen_size.x:
		global_position.x = 0

func shoot_laser():
	var l = laser_scene.instantiate()
	l.global_position = muzzle.global_position
	l.rotation = rotation
	emit_signal("laser_shot", l)

func die():
	if alive == true:
		alive = false
		sprite.visible = false
		cshape.set_deferred("disabled", true)
		emit_signal("died")

func respawn(pos):
	if alive == false:
		alive = true
		global_position = pos
		velocity = Vector2.ZERO
		sprite.visible = true
		cshape.set_deferred("disabled", false)
