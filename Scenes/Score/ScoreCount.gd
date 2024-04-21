extends Label

var score = 0

func _ready():
	Events.taco_delivered.connect(_on_events_taco_delivered)
	_update_text()
	
func _update_text():
	text = "%04d" % score

func _on_events_taco_delivered():
	score += 1
	_update_text()
