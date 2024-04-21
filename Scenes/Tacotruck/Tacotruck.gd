extends Area2D

signal ingredient_collected(ingredient_id: Constants.IngredientType, amount: int)
signal kaboom()

func _ready():
	position = get_viewport_rect().size/2

func _on_body_entered(body):
	if body.ingredient and body.amount:
		if body.ingredient == Constants.IngredientType.BOMB:
			kaboom.emit()
		else:
			ingredient_collected.emit(body.ingredient, body.amount)
		body.queue_free()
