extends TextureProgressBar
class_name OrderCard

@export var ingredient: Constants.IngredientType
@export var reward: int
@export var time: int
@export var background: Texture2D

@onready var timer = $Timer
var is_delivered = false

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.wait_time = time
	timer.one_shot = true
	texture_under = background

func _process(delta):
	if !timer.is_stopped():
		value = (timer.time_left / timer.wait_time) * max_value

func start():
	timer.start()
	print("new order with ingredient = " + Constants.IngredientType.keys()[ingredient] + ", reward: " + str(reward) + ", time: " + str(time))

func on_delivered():
	is_delivered = true
	timer.stop()

func on_finished():
	print("order with ingredient = " + Constants.IngredientType.keys()[ingredient] + " completed")
	GameState.remove_order(get_instance_id())
	queue_free()

func _on_timer_timeout():
	print("LOST BECAUSE ORDER TIMED OUT")
	GameState.reset()
