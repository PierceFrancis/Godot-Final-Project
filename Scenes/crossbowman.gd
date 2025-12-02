extends CharacterBody2D


const SPEED = 300.0
@export var Arrow: PackedScene

@onready var bow_pos = $BowPos



func _physics_process(delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("action_button"):
		shoot()
		
		
	
	#pass
	
func shoot():
	var arrow_instance = Arrow.instantiate()
	
	arrow_instance.global_position = bow_pos.global_position
	get_parent().add_child(arrow_instance)
	
	
	var target = get_global_mouse_position()
	var direction_to_mouse = (target - arrow_instance.global_position).normalized()
	arrow_instance.set_direction(direction_to_mouse)
