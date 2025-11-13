extends CharacterBody2D

#Data fields
#Movement variable field
const MAX_SPEED: float = 300
const ACCELERATION: float = 18.5
const FRICTION: float = 22.5

#Dash vairiable field
const DASH_SPEED: float = 5.0
const DASH_TIME: float = 0.12
var can_dash: bool = true
var dash_timer: float = 0.0
var dash_dir: Vector2 = Vector2.ZERO
const DASH_RELOAD_COST: float = 1.5 
var dash_reload_timer: float = 0.0

#Sword variable field
var can_slash: bool = true

#Export variables
#Player rotate export
@export var turn_speed: float = 10.0  # higher = faster turn

#Sword exports
@export var slash_time: float = 0.2
@export var sword_return_time: float = 0.5
@export var weapon_damage: float = 1.0

func _physics_process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	var target_angle = (mouse_pos - global_position).angle()

	# Smoothly interpolate rotation toward the target
	rotation = lerp_angle(rotation, target_angle, turn_speed * delta)
	
	if dash_timer == 0.0:
		var input: Vector2 = Vector2(Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")).normalized()
			
		var velocity_weight_x: float = 1.0 - exp( -(ACCELERATION if input.x else FRICTION) * delta)
		velocity.x = lerp(velocity.x, input.x * MAX_SPEED, velocity_weight_x)
		var velocity_weight_y: float = 1.0 - exp( -(ACCELERATION if input.y else FRICTION) * delta)
		velocity.y = lerp(velocity.y, input.y * MAX_SPEED, velocity_weight_y)
		
	
	_dash_logic(delta)
	move_and_slide()
	
	if Input.is_action_pressed("attack") and can_slash:
		$Sprite2D/sword/AnimationPlayer.speed_scale = $Sprite2D/sword/AnimationPlayer.get_animation("slash").length / slash_time
		$Sprite2D/sword/AnimationPlayer.play_backwards("slash")
		can_slash = false
		
func spawn_slash():
	pass


func _dash_logic(delta: float) -> void:
	if can_dash and Input.is_action_just_pressed("dash"):
		can_dash = false
		dash_timer = DASH_TIME
		dash_reload_timer = DASH_RELOAD_COST
		
		dash_dir = velocity
		velocity = dash_dir * DASH_SPEED
		
	
	if dash_timer > 0.0:
		dash_timer = max(0.0, dash_timer - delta)
	else:
		if dash_reload_timer > 0.0:
			dash_reload_timer -= delta
		else:
			can_dash = true


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	can_slash = true
