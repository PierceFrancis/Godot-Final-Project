extends CharacterBody2D



const SPEED = 350.0
var health: float = 3.0
#MAKE SURE PLAYER IN THE INSPECTOR IS SET TO THE PLAYER NODE
@export var player : Node2D
@onready var nav_agent : NavigationAgent2D = $NavigationAgent2D
#Hostile or idle Bool
var Hostile : bool = false

var Charging: bool = false

func _physics_process(delta: float) -> void:
	
	if Hostile:
		if Charging:
			charge()
			
		elif !Charging:
			velocity = Vector2(0.0,0.0)
			
			
		
			
func _ready() -> void:
	
	add_to_group("enemy")

func take_damage(weapon_damage: float):
	$AnimationPlayer.play("take_damage")
	health -= weapon_damage
	print("dameged")
	
	if health <= 0.0:
		queue_free()

	

	#move_and_slide()
#create a function for hostile state
func charge():
	#var direction = (player.position - position).normalized()
	#velocity = direction * SPEED
	var current_position: Vector2 = self.global_transform.origin
	var next_path_position: Vector2 = nav_agent.get_next_path_position()
	var new_velocity: Vector2 = current_position.direction_to(next_path_position)
	nav_agent.velocity = new_velocity
	look_at(player.position)
	#move_and_slide()
	
	update_target_position(player.global_transform.origin)
	
func update_target_position(target_pos: Vector2):
	nav_agent.target_position = target_pos




	
	


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = velocity.move_toward(safe_velocity * SPEED, 12.0)
	move_and_slide()


func _on_detection_shape_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		Hostile  = true
		Charging = true


func _on_killbox_body_entered(body: Node2D) -> void:
	Charging = false
	
	velocity = Vector2(0.0,0.0)
	move_and_slide()




func _on_killbox_body_exited(body: Node2D) -> void:
	if Hostile:
		Charging = true
