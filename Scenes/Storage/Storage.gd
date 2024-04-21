extends Node2D

signal item_taken(ingredient)

@export var ingredient: Constants.IngredientType
@export var amount: int = 3
@export var max_storage_capacity: int = 10

func _ready():
	Events.storage_amount_changed.emit(ingredient, amount)


func _on_tacocat_request_take_item(instance_id):
	if instance_id == get_instance_id() && amount > 0:
		amount -= 1
		print("Item " + Constants.IngredientType.keys()[ingredient] + " taken from storage")
		item_taken.emit(ingredient)
		Events.storage_amount_changed.emit(ingredient, amount)

func _on_tacotruck_ingredient_collected(ingredient_id, added_amount):
	if ingredient == ingredient_id:
		amount += min(added_amount, max_storage_capacity)
		Events.storage_amount_changed.emit(ingredient, amount)
