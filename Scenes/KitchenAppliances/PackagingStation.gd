extends Area2D

signal item_placed

var order

@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D
var package_sprite = preload("res://Assets/Sprites/package.png")

var is_packaging = false

func _on_tacocat_request_place_item(instance_id, ingredient):
	order = GameState.find_undelivered_order(ingredient)
	if instance_id == get_instance_id() && order && !is_packaging:
		item_placed.emit()
		is_packaging = true
		order.on_delivered()
		animated_sprite.play()


func _on_animation_finished():
	animated_sprite.stop()
	var sprite = Sprite2D.new()
	sprite.texture = package_sprite
	sprite.position.y = -collision_shape.shape.size.y / 2 - package_sprite.get_size().y / 2
	add_child(sprite)
	var tween = create_tween().set_parallel()
	tween.tween_property(sprite, "position:x", sprite.position.x - 300, 1).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(sprite, "position:y", sprite.position.y - 300, 0.8).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	await tween.finished
	is_packaging = false
	order.on_finished()
	Events.order_delivered.emit(order.reward)
	
