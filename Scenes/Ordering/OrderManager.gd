extends Node

@export var orderables: Array[OrderCard]
@export var max_orders = 10

@onready var container = $HBoxContainer

func _on_timer_timeout():
	if GameState.orders.size() <= max_orders:
		var orderable = orderables[randi() % orderables.size()].duplicate()	
		GameState.orders.push_back(orderable)
		container.add_child(orderable)
		orderable.start()
