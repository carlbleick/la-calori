extends Node2D

signal item_placed
signal item_taken(ingredient)

@export var current_item: Constants.IngredientType

func _on_tacocat_request_place_item(instance_id, ingredient):
	if instance_id == get_instance_id() && current_item == Constants.IngredientType.NONE:
		current_item = ingredient
		print("Item " + Constants.IngredientType.keys()[current_item] + " put on counter")
		item_placed.emit()


func _on_tacocat_request_take_item(instance_id):
	if instance_id == get_instance_id() && current_item != Constants.IngredientType.NONE:
		print("Item " + Constants.IngredientType.keys()[current_item] + " taken from counter")
		item_taken.emit(current_item)
		current_item = Constants.IngredientType.NONE
