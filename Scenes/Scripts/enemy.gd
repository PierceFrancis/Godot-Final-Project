extends CharacterBody2D


const SPEED = 300.0
@export var player : Node2D
#Hostile or idle Bool


func _physics_process(delta: float) -> void:
	
	charge()
	

	#move_and_slide()
#create a function for hostile state
func charge():
	var direction = (player.position - position).normalized()
	velocity = direction * SPEED
	move_and_slide()
	
