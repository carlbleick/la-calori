extends Area2D

signal item_placed

@export var packaging_time = 2.0
var current_packaging_time = 0.0
var order

func _process(delta):
	if current_packaging_time > 0:
		current_packaging_time -= delta

		if current_packaging_time <= 0:
			current_packaging_time = 0
			Events.order_delivered.emit(order.reward)
			order.on_finished()
			print("packaging finished")

func _on_tacocat_request_place_item(instance_id, ingredient):
	order = GameState.find_undelivered_order(ingredient)
	if instance_id == get_instance_id() && current_packaging_time == 0 && order:
		item_placed.emit()
		order.on_delivered()
		current_packaging_time = packaging_time
		# start animation
