extends Area2D

signal item_placed

@export var packaging_time = 2.0
var current_packaging_time = 0.0

func _process(delta):
	if current_packaging_time > 0:
		current_packaging_time -= delta

		if current_packaging_time <= 0:
			current_packaging_time = 0
			Events.taco_delivered.emit()
			print("packaging finished")

func _on_tacocat_request_place_item(instance_id, ingredient):
	if instance_id == get_instance_id() && ingredient == Constants.IngredientType.TACO_FULL && current_packaging_time == 0:
		item_placed.emit()
		current_packaging_time = packaging_time
		# start animation
