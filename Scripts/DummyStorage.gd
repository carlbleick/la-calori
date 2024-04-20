extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_spaceship_dummy_ingredient_collected(ingredient_id, amount):
	print("Ingredient {ingredient_id} collected: Amount {amount}!".format({"ingredient_id":ingredient_id, "amount":amount}))
	pass # Replace with function body.
