extends Node

func play_item_taken(volume = 0):
	$ItemTaken.set_volume_db(volume)
	$ItemTaken.play()

func play_combine():
	$Combine.play()
	
func play_trashed():
	$Trashed.play()

func play_delivered():
	$Delivered.play()

func play_combining_finished():
	$CombiningFinished.play()
	
func play_bomb_exploded():
	$BombExploded.play()

var is_playing_cutting: bool = false

func play_cutting_start():
	is_playing_cutting = true
	play_cutting()
	
func play_cutting_end():
	is_playing_cutting = false
	$Cutting.stop()

func play_cutting():
	if is_playing_cutting:
		$Cutting.play()
		await $Cutting.finished
		await get_tree().create_timer(0.25).timeout 
		play_cutting()
		
var is_playing_cooking: bool = false

func play_cooking_start(is_overcooking = false):
	is_playing_cutting = true
	var timeout = 0.5
	if is_overcooking:
		timeout = 0.25
	play_cooking(timeout)
	
func play_cooking_end():
	is_playing_cutting = false
	$Cooking.stop()

func play_cooking(timeout):
	if is_playing_cutting:
		$Cooking.play()
		await $Cooking.finished
		await get_tree().create_timer(timeout).timeout 
		play_cooking(timeout)

func play_burned():
	$Burned.play()

func play_space_ingredient_collected():
	$SpaceIngredientCollected.play()
		
