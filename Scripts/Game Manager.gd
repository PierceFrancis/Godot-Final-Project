extends Node

var player_pickups: int = 0
var weapon: bool = false
var lives: int = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func pickedUp(pickup: int) -> void:
	player_pickups += 1
	
func weaponUp(pickup: bool) -> void:
	weapon = true
	
	
