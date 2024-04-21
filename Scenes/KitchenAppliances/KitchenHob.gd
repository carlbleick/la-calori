extends Node2D

signal item_placed
signal item_taken(ingredient)

@export var current_item: Constants.IngredientType
@export var cooking_time = 2.0
@export var overcooking_time = 1.0
var current_cooking_time = 0.0

@onready var progress_bar = $TextureProgressBar

func _process(delta):
	if current_cooking_time > 0:
		current_cooking_time -= delta
		if current_cooking_time > overcooking_time:
			progress_bar.value = ((cooking_time - current_cooking_time + overcooking_time) / cooking_time) * progress_bar.max_value
		else:
			current_item = Constants.IngredientType.PROTEIN_COOKED
			var progress = ((overcooking_time - current_cooking_time) / overcooking_time) * progress_bar.max_value
			if int(progress) % 20 < 10:
				progress = 0
			progress_bar.value = progress
			
		if current_cooking_time <= 0:
			current_item = Constants.IngredientType.PROTEIN_OVERCOOKED
			_stop_cooking()

func _stop_cooking():
	current_cooking_time = 0
	progress_bar.hide()
	print("cooking finished")

func _on_tacocat_request_place_item(instance_id, ingredient):
	if instance_id == get_instance_id() && current_item == Constants.IngredientType.NONE && ingredient == Constants.IngredientType.PROTEIN:
		current_item = ingredient
		print("Item " + Constants.IngredientType.keys()[current_item] + " put on hob")
		item_placed.emit()
		print("Start cooking of " + Constants.IngredientType.keys()[current_item])
		current_cooking_time = cooking_time + overcooking_time
		progress_bar.show()


func _on_tacocat_request_take_item(instance_id):
	if instance_id == get_instance_id() && current_item != Constants.IngredientType.NONE:
		print("Item " + Constants.IngredientType.keys()[current_item] + " taken from hob")
		item_taken.emit(current_item)
		current_item = Constants.IngredientType.NONE
		_stop_cooking()
		
