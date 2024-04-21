extends Label

var score = 0

@onready var _animated_sprite = $AnimatedSprite2D

func _ready():
	Events.order_delivered.connect(_on_events_order_delivered)
	_update_text()
	_animated_sprite.play("default")
	
func _update_text():
	text = "%04d" % score

func _on_events_order_delivered(reward):
	score += reward
	_update_text()
