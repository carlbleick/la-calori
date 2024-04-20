extends CharacterBody2D

@export var ingredient: Constants.IngredientType
var amount: int

const SPEED = 250.0

func _physics_process(delta):
	# Move leftward by speed on X-axis
	velocity = Vector2(-SPEED, 0)
	move_and_slide()
	
	if global_position.x < -get_viewport().get_size().x:
		queue_free()
