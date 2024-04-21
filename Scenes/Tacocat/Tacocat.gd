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

func _ready():
	line_size = get_tree().root.content_scale_size.y / 3
	tile_size = taco_truck_sprite.texture.get_height() / 5
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

# Cooking
@export var current_item: Constants.IngredientType

signal request_take_item(instance_id)
signal request_place_item(instance_id, ingredient)

func _input(event):
	ray.force_raycast_update()
	if event.is_action_pressed("interact") && ray.is_colliding():
		if current_item == Constants.IngredientType.NONE:
			request_take_item.emit(ray.get_collider().get_instance_id())
		else:
			request_place_item.emit(ray.get_collider().get_instance_id(), current_item)


func _on_storage_item_taken(ingredient):
	current_item = ingredient
	print("Item " + Constants.IngredientType.keys()[current_item] + " in hand")

func _on_kitchen_counter_item_placed():
	current_item = Constants.IngredientType.NONE
	print("Item " + Constants.IngredientType.keys()[current_item] + " in hand")

func _on_kitchen_counter_item_taken(ingredient):
	current_item = ingredient
	print("Item " + Constants.IngredientType.keys()[current_item] + " in hand")
