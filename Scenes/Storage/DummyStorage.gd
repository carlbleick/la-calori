extends Node2D


func _on_spaceship_dummy_ingredient_collected(ingredient_id, amount):
	print("Ingredient {ingredient_id} collected: Amount {amount}!".format({"ingredient_id":ingredient_id, "amount":amount}))
	pass # Replace with function body.
