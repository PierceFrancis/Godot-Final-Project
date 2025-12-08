extends Node

var player_pickups: int = 0
var weapon: bool = false
var lives: int = 3

var current_level_path: String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if lives == 0:
		lives = 3
		weapon = false
		get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
		

func pickedUp(pickup: int) -> void:
	player_pickups += 1
	
func weaponUp(pickup: bool) -> void:
	weapon = true
	
func player_won():
	print("Level complete")
	get_tree().change_scene_to_file("res://Scenes/win_screen.tscn")
	
