extends Node

var orders = []
var gameTime = 0 
var order_probability = 0.1
var lastTime

func _ready():
	lastTime = Time.get_ticks_msec()

func _process(_delta):
	var newTime = Time.get_ticks_msec()
	if newTime - lastTime >= 1000:
		order_probability += 0.0005
		lastTime = newTime

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
	
