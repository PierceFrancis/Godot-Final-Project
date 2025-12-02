extends CharacterBody2D


const SPEED = 300.0
@export var Arrow: PackedScene
@export var main : Node2D
var health: float = 3.0

@onready var bow_pos = $BowPos
@onready var bow_dir = $BowDir
@onready var attack_cooldown = $Attackcooldown

signal enemy_shot_arrow(arrow, postion, direction)

func _physics_process(delta: float) -> void:
	look_at(get_global_mouse_position())

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("action_button"):
		shoot()
		
		
	
	#pass
	
func shoot():
	if attack_cooldown.is_stopped():
		var arrow_instance = Arrow.instantiate()
		var direction = (bow_dir.global_position - bow_pos.global_position).normalized()
		emit_signal("enemy_shot_arrow",arrow_instance,bow_pos.global_position,direction)
		attack_cooldown.start()
	else:
		pass
func handle_hit():
	health -= 1.0
	print("crossbowmen hit")
