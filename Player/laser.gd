extends Area2D

@export var speed := 500.0

var movment_vector := Vector2(0, -1)


func _physics_process(delta):
	global_position += movment_vector.rotated(rotation) * speed * delta


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()


func _on_area_entered(area):
	if area is Asteroid:
		var asteroid = area
		asteroid.explode()
		queue_free()
