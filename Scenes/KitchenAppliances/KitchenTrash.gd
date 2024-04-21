extends Area2D

signal item_placed

func _on_tacocat_request_place_item(instance_id, ingredient):
	if instance_id == get_instance_id():
		item_placed.emit()
		SoundPlayer.play_trashed()
		print('Item ' + Constants.IngredientType.keys()[ingredient] + ' moved to trash')
