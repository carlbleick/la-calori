extends ParallaxBackground

var speed: int = 150
var direction = Vector2.LEFT

func _process(delta):
	scroll_offset += direction * speed * delta
