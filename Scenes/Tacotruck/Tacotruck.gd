extends Area2D

signal ingredient_collected(ingredient_id: Constants.IngredientType, amount: int)
signal kaboom()

@onready var _animated_sprite = $AnimatedSprite2D

func _ready():
	position = get_viewport_rect().size/2
	position.x = get_viewport_rect().size.x / 2.0 / 1.618
	_animated_sprite.play("default")

func _on_body_entered(body):
	if body.ingredient and body.amount:
		if body.ingredient == Constants.IngredientType.BOMB:
			kaboom.emit()
			SoundPlayer.play_bomb_exploded()
		else:
			ingredient_collected.emit(body.ingredient, body.amount)
			SoundPlayer.play_space_ingredient_collected()
		body.queue_free()
