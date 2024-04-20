extends StaticBody2D

signal item_taken(ingredient)

@export var ingredient: Constants.IngredientType
@export var amount: int = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _on_player_request_take_item(instance_id):
	if instance_id == get_instance_id() && amount > 0:
		amount -= 1
		item_taken.emit(ingredient)
