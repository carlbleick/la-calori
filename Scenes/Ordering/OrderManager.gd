extends Node

@export var orderables: Array[OrderCard]
@export var probabilities: Array[float]
@export var max_orders = 10

@onready var container = $HBoxContainer

func _ready():
	assert(probabilities.size() == orderables.size())

func _on_timer_timeout():
	if randf() >= GameState.order_probability:
		return
	
	if GameState.orders.size() <= max_orders:
		var random_f = randf()
		var index = 0
		for i in range(probabilities.size()):
			var prob = probabilities[i]
			if random_f <= prob:
				index = i
				break
			else:
				random_f -= prob
		var orderable = orderables[index].duplicate()	
		GameState.orders.push_back(orderable)
		container.add_child(orderable)
		orderable.start()
