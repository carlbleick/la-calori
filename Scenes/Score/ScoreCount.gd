extends Label

var score = 0

func _ready():
	Events.order_delivered.connect(_on_events_order_delivered)
	_update_text()
	
func _update_text():
	text = "%04d" % score

func _on_events_order_delivered(reward):
	score += reward
	_update_text()
