extends Node2D

@export var ingredient_scenes: Array[PackedScene]
@export var lane_probability: Array[float] = [0.45, 0.1, 0.45]


# add spawner configuration => which when where
func _on_timer_timeout():
	var ingredient = get_random_ingredient()
	ingredient.global_position = get_random_position()
	ingredient.amount = 1 + randi() % 3
	add_child(ingredient)


func get_random_ingredient():
	return ingredient_scenes[randi() % 4].instantiate()


func get_random_position():
	# split into 3 lanes
	var viewport_height = get_tree().root.content_scale_size.y
	var middle = viewport_height / 2
	var lane_height = 96
	var lanes = [middle - lane_height, middle, middle + lane_height]
	
	var random_lane_index: int = 0
	var random_f = randf()
	for i in range(lane_probability.size()):
		var prob = lane_probability[i]
		if random_f <= prob:
			random_lane_index = i
			break
		else:
			random_f -= prob
	var random_lane = lanes[random_lane_index]

	var spawn_x = get_tree().root.content_scale_size.x
	return Vector2(spawn_x, random_lane)
