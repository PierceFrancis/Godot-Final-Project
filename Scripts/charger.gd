extends CharacterBody2D

const SPEED = 350.0
var health: float = 3.0
#MAKE SURE PLAYER IN THE INSPECTOR IS SET TO THE PLAYER NODE
@export var player : Node2D
@onready var nav_agent : NavigationAgent2D = $NavigationAgent2D

#attack variables
@onready var spear = $Sprite2D/spear
@onready var chargerAttack = $ChargerAttack
@onready var spear_hitbox = $ChargerAttack/Area2D/CollisionShape2D

# Spear timing/damage
@export var thrust_time: float = 0.2
@export var spear_return_time: float = 0.5
@export var weapon_damage: float = 1.0

@onready var spear_default_rotation: float
@onready var spear_default_position: Vector2

@onready var attack_cooldown = $attackCooldown

var can_thrust: bool = true


#State bools

#could be replaced with FSM
var Hostile : bool = false
var Charging: bool = false
var Attacking: bool = false

func _physics_process(delta: float) -> void:
	
	if Hostile:
		if Charging:
			charge()
			
		elif !Charging:
			velocity = Vector2(0.0,0.0)
			
			
		
	
		# attack stuff
	if Attacking and can_thrust and attack_cooldown.is_stopped():
		can_thrust = false
		Attacking = false
		print("tyring to attack")
		
		var ap = $Sprite2D/spear/AnimationPlayer
		ap.speed_scale = ap.get_animation("thrust").length / thrust_time
		ap.play("thrust")
		
		
			

func spawn_thrust():
	chargerAttack.global_position = spear.global_position
	chargerAttack.global_rotation = spear.global_rotation
	
	chargerAttack.show()
	spear_hitbox.disabled = false

	# Match animation speed
	

	# Apply damage value
	chargerAttack.weapon_damage = weapon_damage

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "thrust":
		can_thrust = true
		#print("anim done")

		# Hide the spear hitbox
		chargerAttack.hide()
		spear_hitbox.disabled = true

		
		spear.rotation = spear_default_rotation
		spear.position = spear_default_position
		
		spear_hitbox.rotation = 0
		
		#chargerAttack.rotation = 0
	
func _ready() -> void:
	
	add_to_group("enemy")
	
	#hide spear hitbox 
	
	spear_hitbox.disabled = true

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
	if body.name == "Player":
		Charging = false
		Attacking = true
	
		velocity = Vector2(0.0,0.0)
		
		move_and_slide()




func _on_killbox_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		if Hostile:
			Charging = true
	Attacking =false
	can_thrust = true
