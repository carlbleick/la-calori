extends Node2D

@export var ingredient_scenes: Array[PackedScene]
@export var lane_probability: Array[float] = [0.45, 0.1, 0.45]

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# add spawner configuration => which when where
func _on_timer_timeout():
	var ingredient = get_random_ingredient()
	ingredient.global_position = get_random_position()
	ingredient.amount = randi() % 3
	add_child(ingredient)


func get_random_ingredient():
	return ingredient_scenes[randi() % 3].instantiate()


func get_random_position():
	# split into 3 lanes
	var viewport_height = get_viewport().get_size().y
	var lane_height = viewport_height / 3
	var lanes = [[0, lane_height], [lane_height, 2 * lane_height], [2 * lane_height, 3 * lane_height]]
	
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
	
	var spawn_x = get_viewport().get_size().x
	var spawn_y = random_lane[0] + (lane_height / 2)
	return Vector2(spawn_x, spawn_y)
