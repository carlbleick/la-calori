extends Node2D

signal item_placed
signal item_taken(ingredient)

@export var current_item: Constants.IngredientType

func _on_player_request_place_item(instance_id, ingredient):
	if instance_id == get_instance_id() && current_item == Constants.IngredientType.NONE:
		current_item = ingredient
		item_placed.emit(ingredient)


func _on_player_request_take_item(instance_id):
	if instance_id == get_instance_id() && current_item != Constants.IngredientType.NONE:
		item_taken.emit(current_item)
		current_item = Constants.IngredientType.NONE
