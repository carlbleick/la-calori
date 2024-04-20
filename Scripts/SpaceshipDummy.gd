extends Area2D

signal ingredient_collected(ingredient_id: Constants.IngredientType, amount: int)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.ingredient and body.amount:
		ingredient_collected.emit(body.ingredient, body.amount)
		body.queue_free()
