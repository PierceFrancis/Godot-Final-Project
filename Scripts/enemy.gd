extends CharacterBody2D


const SPEED = 250.0
@export var player : Node2D
#Hostile or idle Bool
var Hostile : bool = false

func _physics_process(delta: float) -> void:
	if Hostile:
		charge()
	

	#move_and_slide()
#create a function for hostile state
func charge():
	var direction = (player.position - position).normalized()
	velocity = direction * SPEED
	move_and_slide()
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		Hostile  = true
	
