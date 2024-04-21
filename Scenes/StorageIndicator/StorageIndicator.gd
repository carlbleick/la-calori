extends TextureProgressBar

@export var current_ingredient: Constants.IngredientType

func _ready():
	Events.storage_amount_changed.connect(_on_events_storage_amount_changed)

func _on_events_storage_amount_changed(ingredient, new_amount):
	if ingredient == current_ingredient:
		value = new_amount
