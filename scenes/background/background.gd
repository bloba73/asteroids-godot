extends ParallaxBackground

var shift_rate = 100

func _process(delta: float) -> void:
	scroll_offset.x -= shift_rate * delta
