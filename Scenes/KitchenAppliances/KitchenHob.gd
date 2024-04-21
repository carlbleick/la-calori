extends Node2D

signal item_placed
signal item_taken(ingredient)

@export var current_item: Constants.IngredientType
@export var cooking_time = 2.0
@export var overcooking_time = 1.0
var current_cooking_time = 0.0

var food_textures = {
	Constants.IngredientType.PROTEIN: preload("res://Assets/Sprites/food-icon-protein.png"),
	Constants.IngredientType.PROTEIN_COOKED: preload("res://Assets/Sprites/food-icon-protein-prepared.png"),
	Constants.IngredientType.PROTEIN_OVERCOOKED: preload("res://Assets/Sprites/food-icon-protein-burned.png"),
}
var current_food_sprite: Sprite2D

@onready var progress_bar = $TextureProgressBar
func _process(delta):
	if current_cooking_time > 0:
		var prev_cooking_time = current_cooking_time
		current_cooking_time -= delta
		if current_cooking_time > overcooking_time:
			progress_bar.value = ((cooking_time - current_cooking_time + overcooking_time) / cooking_time) * progress_bar.max_value
		else:
			if prev_cooking_time > overcooking_time:
				current_item = Constants.IngredientType.PROTEIN_COOKED
				SoundPlayer.play_cooking_end()
				SoundPlayer.play_cooking_start(true)
				updateSprite()
			var progress = ((overcooking_time - current_cooking_time) / overcooking_time) * progress_bar.max_value
			if int(progress) % 20 < 10:
				progress = 0
			progress_bar.value = progress
			
		if current_cooking_time <= 0:
			current_item = Constants.IngredientType.PROTEIN_OVERCOOKED
			updateSprite()
			SoundPlayer.play_burned()
			_stop_cooking()

func _stop_cooking():
	current_cooking_time = 0
	progress_bar.hide()
	SoundPlayer.play_cooking_end()
	print("cooking finished")

func _on_tacocat_request_place_item(instance_id, ingredient):
	if instance_id == get_instance_id() && current_item == Constants.IngredientType.NONE && ingredient == Constants.IngredientType.PROTEIN:
		current_item = ingredient
		print("Item " + Constants.IngredientType.keys()[current_item] + " put on hob")
		item_placed.emit()
		updateSprite()
		print("Start cooking of " + Constants.IngredientType.keys()[current_item])
		current_cooking_time = cooking_time + overcooking_time
		progress_bar.show()
		SoundPlayer.play_cooking_start()

func _on_tacocat_request_take_item(instance_id):
	if instance_id == get_instance_id() && current_item != Constants.IngredientType.NONE:
		print("Item " + Constants.IngredientType.keys()[current_item] + " taken from hob")
		item_taken.emit(current_item)
		current_item = Constants.IngredientType.NONE
		_stop_cooking()
		updateSprite()

func updateSprite():
	if current_food_sprite:
		current_food_sprite.queue_free()
		current_food_sprite = null
	if food_textures.has(current_item):
		var sprite_node = Sprite2D.new()
		sprite_node.texture = food_textures[current_item]
		sprite_node.z_index = 2
		current_food_sprite = sprite_node
		add_child(sprite_node)
