extends Area2D

var tile_size = 64
var inputs = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}
			
@export var sprite: Sprite2D
@export var parentNode: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size/2
	tile_size = sprite.texture.get_size() / 2
	print(tile_size)
	parentNode.position = position.snapped(Vector2.ONE * tile_size)
	parentNode.position += Vector2.ONE * tile_size/2

func _unhandled_input(event):
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(dir)

func move(dir):
	position += inputs[dir] * tile_size
	parentNode.position += inputs[dir] * tile_size
