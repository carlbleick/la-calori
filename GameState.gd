extends Node

var orders = []

func remove_order(instance_id):
	for i in range(orders.size()):
		if orders[i].get_instance_id() == instance_id:
			orders.remove_at(i)
			break

func find_undelivered_order(ingredient):
	for order in orders:
		if !order.is_delivered && order.ingredient == ingredient:
			return order
	return null
	
func reset():
	orders.clear()
	get_tree().reload_current_scene()
	
