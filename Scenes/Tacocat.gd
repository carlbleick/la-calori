extends Area2D


var line_size = 360
var tile_size = 120
var inputs = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}
@onready var ray = $RayCast2D
@export var taco_truck: Node2D
@export var taco_truck_sprite: Sprite2D

func updateSizes():
	line_size = get_viewport().get_size().y / 3
	tile_size = taco_truck_sprite.texture.get_height() / 3

func resize():
	updateSizes();

func _ready():
	get_tree().get_root().size_changed.connect(resize)
	updateSizes();
	taco_truck.position = taco_truck.position.snapped(Vector2.ONE * line_size)
	taco_truck.position += Vector2.ONE * line_size/2
	pass

func _unhandled_input(event):
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(dir)

func move(dir):
	ray.target_position = inputs[dir] * tile_size
	ray.force_raycast_update()
	if !ray.is_colliding():
		position += inputs[dir] * tile_size
		if dir == "up" || dir == "down":
			taco_truck.position += inputs[dir] * line_size

