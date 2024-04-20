extends CharacterBody2D

const Storage = preload("res://Scenes/Storage.gd")

@export var current_item: Constants.IngredientType

signal request_take_item(instance_id)
signal request_place_item(instance_id, ingredient)

@onready var ray = $RayCast2D

func _input(event):
	if event.is_action_pressed("interact") && ray.is_colliding():
		if current_item == Constants.IngredientType.NONE:
			request_take_item.emit(ray.get_collider().get_instance_id())
		else:
			request_place_item.emit(ray.get_collider().get_instance_id(), current_item)


func _on_storage_item_taken(ingredient):
	current_item = ingredient

func _on_counter_item_placed():
	current_item = Constants.IngredientType.NONE
	
func _on_counter_item_taken(ingredient):
	current_item = ingredient
