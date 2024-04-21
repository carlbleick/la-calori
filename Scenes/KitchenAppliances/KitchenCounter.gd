extends Node2D

signal item_placed
signal item_taken(ingredient)

@export var current_item: Constants.IngredientType
@export var processing_time = 2.0
var current_processing_time = 0.0

@onready var progress_bar = $TextureProgressBar

func _process(delta):
	if current_processing_time > 0:
		if Input.is_action_pressed("process"):
			current_processing_time -= delta
			progress_bar.value = ((processing_time - current_processing_time) / processing_time) * progress_bar.max_value
			if current_processing_time <= 0:
				current_processing_time = 0
				progress_bar.hide()
				current_item = Constants.IngredientType.VEGGIES_CUTTED
				print("processing finished")
		else:
			progress_bar.hide()
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
			# combination of taco ingredients
			Constants.IngredientType.TACO:
				match (ingredient):
					Constants.IngredientType.VEGGIES_CUTTED:
						current_item = Constants.IngredientType.TACO_VEGGIES
						item_placed.emit()
					Constants.IngredientType.PROTEIN_COOKED:
						current_item = Constants.IngredientType.TACO_PROTEIN
						item_placed.emit()
					_:
						print("You cannot place " + Constants.IngredientType.keys()[ingredient] + " on " + Constants.IngredientType.keys()[current_item])
			Constants.IngredientType.VEGGIES_CUTTED:
				if (ingredient == Constants.IngredientType.TACO):
					current_item = Constants.IngredientType.TACO_VEGGIES
					item_placed.emit()
				else:
					print("You cannot place " + Constants.IngredientType.keys()[ingredient] + " on " + Constants.IngredientType.keys()[current_item])
			Constants.IngredientType.PROTEIN_COOKED:
				if (ingredient == Constants.IngredientType.TACO):
					current_item = Constants.IngredientType.TACO_PROTEIN
					item_placed.emit()
				else:
					print("You cannot place " + Constants.IngredientType.keys()[ingredient] + " on " + Constants.IngredientType.keys()[current_item])
			Constants.IngredientType.TACO_VEGGIES:
				if (ingredient == Constants.IngredientType.PROTEIN_COOKED):
					current_item = Constants.IngredientType.TACO_FULL
					item_placed.emit()
				else:
					print("You cannot place " + Constants.IngredientType.keys()[ingredient] + " on " + Constants.IngredientType.keys()[current_item])
			Constants.IngredientType.TACO_PROTEIN:
				if (ingredient == Constants.IngredientType.VEGGIES_CUTTED):
					current_item = Constants.IngredientType.TACO_FULL
					item_placed.emit()
				else:
					print("You cannot place " + Constants.IngredientType.keys()[ingredient] + " on " + Constants.IngredientType.keys()[current_item])

func _on_tacocat_request_take_item(instance_id):
	if instance_id == get_instance_id() && current_item != Constants.IngredientType.NONE:
		print("Item " + Constants.IngredientType.keys()[current_item] + " taken from counter")
		item_taken.emit(current_item)
		current_item = Constants.IngredientType.NONE


func _on_tacocat_request_process_item(instance_id):
	if instance_id == get_instance_id() && current_item == Constants.IngredientType.VEGGIES:
		print("Start processing of " + Constants.IngredientType.keys()[current_item])
		current_processing_time = processing_time
		progress_bar.show()
		
