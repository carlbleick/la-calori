extends Area2D

var animation_speed = 7
var moving = false
var line_size = 96
var tile_size = 16
var inputs = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}
@onready var ray = $RayCast2D
@export var taco_truck: Node2D

@onready var _animated_sprite = $AnimatedSprite2D

var food_marker_textures = {
	Constants.IngredientType.TACO: preload("res://Assets/Sprites/food-marker-shell.png"),
	Constants.IngredientType.VEGGIES: preload("res://Assets/Sprites/food-marker-veggies.png"),
	Constants.IngredientType.PROTEIN: preload("res://Assets/Sprites/food-marker-protein.png"),
	Constants.IngredientType.VEGGIES_CUTTED: preload("res://Assets/Sprites/food-marker-veggies-prepared.png"),
	Constants.IngredientType.PROTEIN_COOKED: preload("res://Assets/Sprites/food-marker-protein-prepared.png"),
	Constants.IngredientType.PROTEIN_OVERCOOKED: preload("res://Assets/Sprites/food-marker-protein-burned.png"),
	Constants.IngredientType.TACO_VEGGIES: preload("res://Assets/Sprites/food-marker-shell-veggies.png"),
	Constants.IngredientType.TACO_PROTEIN: preload("res://Assets/Sprites/food-marker-shell-protein.png"),
	Constants.IngredientType.TACO_FULL: preload("res://Assets/Sprites/food-marker-taco.png")
}
var current_food_marker_sprite: Sprite2D


func _ready():
	taco_truck.position = taco_truck.position.snapped(Vector2.ONE * line_size)
	taco_truck.position += Vector2.ONE * line_size/2
	_animated_sprite.play()

func _unhandled_input(event):
	if moving:
		return
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(dir)

func move(dir):
	ray.target_position = inputs[dir] * tile_size
	ray.force_raycast_update()
	_animated_sprite.play(dir)
	if !ray.is_colliding():
		moving = true
		var tweenChar = create_tween().set_parallel()
		tweenChar.tween_property(self, "position", position + inputs[dir] *  tile_size, 1.0/animation_speed).set_trans(Tween.TRANS_SINE)
		if dir == "up" || dir == "down":
			tweenChar.tween_property(taco_truck, "position", taco_truck.position + inputs[dir] *  line_size, 1.0/animation_speed).set_trans(Tween.TRANS_SINE)
		await tweenChar.finished
		moving = false

# Cooking
@export var current_item: Constants.IngredientType

signal request_take_item(instance_id)
signal request_place_item(instance_id, ingredient)
signal request_process_item(instance_id)

func _input(event):
	ray.force_raycast_update()
	if ray.is_colliding():
		var instance_id = ray.get_collider().get_instance_id()
		if event.is_action_pressed("interact"):
			if current_item == Constants.IngredientType.NONE:
				request_take_item.emit(instance_id)
			else:
				request_place_item.emit(instance_id, current_item)
		elif event.is_action_pressed("process"):
			request_process_item.emit(instance_id)

func _on_item_placed():
	current_item = Constants.IngredientType.NONE
	print("Item " + Constants.IngredientType.keys()[current_item] + " in hand")
	if current_food_marker_sprite:
		current_food_marker_sprite.queue_free()
		current_food_marker_sprite = null

func _on_item_taken(ingredient):
	current_item = ingredient
	print("Item " + Constants.IngredientType.keys()[current_item] + " in hand")
	var sprite_node = Sprite2D.new()
	if food_marker_textures.has(current_item):
		sprite_node.texture = food_marker_textures[current_item]
		sprite_node.position = Vector2(0, -16)
		sprite_node.z_index = 200
		current_food_marker_sprite = sprite_node
		add_child(sprite_node)
