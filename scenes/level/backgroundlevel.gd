extends ParallaxBackground

var shift_rate = 10

func _process(delta: float) -> void:
	scroll_offset.x -= shift_rate * delta
