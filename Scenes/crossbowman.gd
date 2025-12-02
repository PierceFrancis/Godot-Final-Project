extends CharacterBody2D


const SPEED = 300.0
@export var Arrow: PackedScene
@export var main : Node2D

@onready var bow_pos = $BowPos
@onready var bow_dir = $BowDir

signal enemy_shot_arrow(arrow, postion, direction)

func _physics_process(delta: float) -> void:
	look_at(get_global_mouse_position())

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("action_button"):
		shoot()
		
		
	
	#pass
	
func shoot():
	var arrow_instance = Arrow.instantiate()
	
	#arrow_instance.global_position = bow_pos.global_position
	
	
	#var target = get_global_mouse_position()
	#old direction var
	#var direction_to_mouse = (target - bow_pos.global_position).normalized()
	
	var direction = (bow_dir.global_position - bow_pos.global_position).normalized()
	#arrow_instance.set_direction(direction_to_mouse)
	emit_signal("enemy_shot_arrow",arrow_instance,bow_pos.global_position,direction)
