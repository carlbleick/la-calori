extends MarginContainer

func _ready():
	SoundPlayer.play_theme()

func _on_texture_button_pressed():
	print('pressed')
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
	


func _on_button_pressed():
	print("is this pressed")
