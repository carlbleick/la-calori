extends Node2D

signal item_placed
signal item_taken(ingredient)

@export var current_item: Constants.IngredientType
@export var processing_time = 2.0
var current_processing_time = 0.0

@onready var progress_bar = $TextureProgressBar

var food_textures = {
	Constants.IngredientType.TACO: preload("res://Assets/Sprites/food-icon-shell.png"),
	Constants.IngredientType.VEGGIES: preload("res://Assets/Sprites/food-icon-veggies.png"),
	Constants.IngredientType.PROTEIN: preload("res://Assets/Sprites/food-icon-protein.png"),
	Constants.IngredientType.VEGGIES_CUTTED: preload("res://Assets/Sprites/food-icon-veggies-prepared.png"),
	Constants.IngredientType.PROTEIN_COOKED: preload("res://Assets/Sprites/food-icon-protein-prepared.png"),
	Constants.IngredientType.PROTEIN_OVERCOOKED: preload("res://Assets/Sprites/food-icon-protein-burned.png"),
	Constants.IngredientType.TACO_VEGGIES: preload("res://Assets/Sprites/food-icon-shell-veggies.png"),
	Constants.IngredientType.TACO_PROTEIN: preload("res://Assets/Sprites/food-icon-shell-protein.png"),
	Constants.IngredientType.TACO_FULL: preload("res://Assets/Sprites/food-icon-taco.png"),
}
var current_food_sprite: Sprite2D

func _process(delta):
	if current_processing_time > 0:
		if Input.is_action_pressed("process"):
			current_processing_time -= delta
			progress_bar.value = ((processing_time - current_processing_time) / processing_time) * progress_bar.max_value
			if current_processing_time <= 0:
				current_processing_time = 0
				progress_bar.hide()
				SoundPlayer.play_cutting_end()
				current_item = Constants.IngredientType.VEGGIES_CUTTED
				print("processing finished")
				updateSprite()
		else:
			progress_bar.hide()
			SoundPlayer.play_cutting_end()
			current_processing_time = 0
			print("processing aborted")	

func _on_tacocat_request_place_item(instance_id, ingredient):
	if instance_id == get_instance_id():
		match (current_item):
			# nothing is placed
			Constants.IngredientType.NONE:
				current_item = ingredient
				print("Item " + Constants.IngredientType.keys()[current_item] + " put on counter")
				item_placed.emit()
				SoundPlayer.play_combine()
			# combination of taco ingredients
			Constants.IngredientType.TACO:
				match (ingredient):
					Constants.IngredientType.VEGGIES_CUTTED:
						current_item = Constants.IngredientType.TACO_VEGGIES
						item_placed.emit()
						SoundPlayer.play_combine()
					Constants.IngredientType.PROTEIN_COOKED:
						current_item = Constants.IngredientType.TACO_PROTEIN
						item_placed.emit()
						SoundPlayer.play_combine()
					_:
						print("You cannot place " + Constants.IngredientType.keys()[ingredient] + " on " + Constants.IngredientType.keys()[current_item])
			Constants.IngredientType.VEGGIES_CUTTED:
				match (ingredient):
					Constants.IngredientType.TACO:
						current_item = Constants.IngredientType.TACO_VEGGIES
						item_placed.emit()
						SoundPlayer.play_combine()
					Constants.IngredientType.TACO_PROTEIN:
						current_item = Constants.IngredientType.TACO_FULL
						item_placed.emit()
						SoundPlayer.play_combining_finished()
					_:
						print("You cannot place " + Constants.IngredientType.keys()[ingredient] + " on " + Constants.IngredientType.keys()[current_item])
			Constants.IngredientType.PROTEIN_COOKED:
				match (ingredient):
					Constants.IngredientType.TACO:
						current_item = Constants.IngredientType.TACO_PROTEIN
						item_placed.emit()
						SoundPlayer.play_combine()
					Constants.IngredientType.TACO_VEGGIES:
						current_item = Constants.IngredientType.TACO_FULL
						item_placed.emit()
						SoundPlayer.play_combining_finished()
					_:
						print("You cannot place " + Constants.IngredientType.keys()[ingredient] + " on " + Constants.IngredientType.keys()[current_item])
			Constants.IngredientType.TACO_VEGGIES:
				if (ingredient == Constants.IngredientType.PROTEIN_COOKED):
					current_item = Constants.IngredientType.TACO_FULL
					item_placed.emit()
					SoundPlayer.play_combining_finished()
				else:
					print("You cannot place " + Constants.IngredientType.keys()[ingredient] + " on " + Constants.IngredientType.keys()[current_item])
			Constants.IngredientType.TACO_PROTEIN:
				if (ingredient == Constants.IngredientType.VEGGIES_CUTTED):
					current_item = Constants.IngredientType.TACO_FULL
					item_placed.emit()
					SoundPlayer.play_combining_finished()
				else:
					print("You cannot place " + Constants.IngredientType.keys()[ingredient] + " on " + Constants.IngredientType.keys()[current_item])
		updateSprite()

func _on_tacocat_request_take_item(instance_id):
	if instance_id == get_instance_id() && current_item != Constants.IngredientType.NONE:
		print("Item " + Constants.IngredientType.keys()[current_item] + " taken from counter")
		item_taken.emit(current_item)
		current_item = Constants.IngredientType.NONE
		updateSprite()
		SoundPlayer.play_combine()


func _on_tacocat_request_process_item(instance_id):
	if instance_id == get_instance_id() && current_item == Constants.IngredientType.VEGGIES:
		print("Start processing of " + Constants.IngredientType.keys()[current_item])
		current_processing_time = processing_time
		progress_bar.show()
		SoundPlayer.play_cutting_start()

func updateSprite():
	if current_food_sprite:
		current_food_sprite.queue_free()
		current_food_sprite = null
	if food_textures.has(current_item):
		var sprite_node = Sprite2D.new()
		sprite_node.texture = food_textures[current_item]
		sprite_node.z_index = 2
		current_food_sprite = sprite_node
		add_child(sprite_node)
