extends CharacterBody2D


# Movement variables
const MAX_SPEED: float = 300
const ACCELERATION: float = 18.5
const FRICTION: float = 22.5

# Dash variables
const DASH_SPEED: float = 5.0
const DASH_TIME: float = 0.12
var can_dash: bool = true
var dash_timer: float = 0.0
var dash_dir: Vector2 = Vector2.ZERO
const DASH_RELOAD_COST: float = 1.5
var dash_reload_timer: float = 0.0

# Pull and push variables
var can_pull: bool = true
var can_push: bool = true
const PULL_SPEED: float = 10.0

# Sword variables
var can_slash: bool = true

#Throwable variables
var throwable_item_scene: PackedScene = preload("res://Scenes/thrown_sword.tscn")

# Rotation
@export var turn_speed: float = 10.0

# Sword timing/damage
@export var slash_time: float = 0.2
@export var sword_return_time: float = 0.5
@export var weapon_damage: float = 1.0

# Nodes
@onready var sword = $Sprite2D/sword                 # The visible sword sprite
@onready var slash = $sword_slash                    # The slash hitbox + animation scene
@onready var slash_anim = $sword_slash/Sprite2D/AnimationPlayer
@onready var slash_hitbox = $sword_slash/Area2D/CollisionShape2D

# Cached transform
var sword_default_rotation: float
var sword_default_offset: Vector2


func _ready():
	sword_default_rotation = sword.rotation
	sword_default_offset = sword.offset
	print(sword.offset)
	print(sword.rotation)

	# Hide slash hitbox initially
	slash.hide()
	slash_hitbox.disabled = true


func _physics_process(delta: float) -> void:
	sword.visible = GameManager.weapon
	# Rotate player toward mouse
	var mouse_pos = get_global_mouse_position()
	var target_angle = (mouse_pos - global_position).angle()
	rotation = lerp_angle(rotation, target_angle, turn_speed * delta)

	# Movement
	if dash_timer == 0.0:
		var input_vec: Vector2 = Vector2(
			Input.get_axis("move_left", "move_right"),
			Input.get_axis("move_up", "move_down")
		).normalized()

		var w_x = 1.0 - exp(-(ACCELERATION if input_vec.x else FRICTION) * delta)
		var w_y = 1.0 - exp(-(ACCELERATION if input_vec.y else FRICTION) * delta)
		velocity.x = lerp(velocity.x, input_vec.x * MAX_SPEED, w_x)
		velocity.y = lerp(velocity.y, input_vec.y * MAX_SPEED, w_y)

	_dash_logic(delta)
	move_and_slide()

	# Sword attack
	if GameManager.weapon and Input.is_action_pressed("attack") and can_slash:
		can_slash = false

		# Sword animation speed
		var ap = $Sprite2D/sword/AnimationPlayer
		ap.speed_scale = ap.get_animation("slash").length / slash_time
		ap.play("slash")

		spawn_slash()
	
	if GameManager.weapon and Input.is_action_pressed("throw_weapon"):
		throw_sword()
		
	if can_pull and Input.is_action_pressed("pull"):
		pull_action()

func spawn_slash():

	# Match slash to sword position & rotation
	slash.global_position = sword.global_position
	slash.global_rotation = sword.global_rotation

	# Enable hitbox and show the slash
	slash.show()
	slash_hitbox.disabled = false

	# Match animation speed
	slash_anim.speed_scale = slash_anim.get_animation("slash").length / slash_time
	slash_anim.play("slash")

	# Apply damage value
	slash.weapon_damage = weapon_damage


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
func take_damage(weapon_damage: float):
	#$Sprite2D/AnimationPlayer.play("take_damage")
	GameManager.lives -= weapon_damage
func handle_hit():
	GameManager.lives -= 1.0
	print("player hit",GameManager.lives)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "slash":
		can_slash = true

		# Hide the slash hitbox
		slash.hide()
		slash_hitbox.disabled = true

		# Reset sword position
		sword.rotation = sword_default_rotation
		sword.offset = sword_default_offset
		
func throw_sword() -> void:
	var throwable = throwable_item_scene.instantiate()
	get_tree().current_scene.add_child(throwable)

	# spawn in front
	var spawn_offset := Vector2(32, 0).rotated(rotation)
	throwable.global_position = global_position + spawn_offset

	# add random spread (example ±15°)
	var spread := deg_to_rad(randf_range(-15, 15))
	throwable.direction = Vector2.RIGHT.rotated(rotation + spread)
	throwable.rotation = rotation + spread

	# tell the projectile who threw it (no has_variable check needed)
	throwable.ignore_body = self

	# Reduce the correct pickup counter
	GameManager.weapon = false
	
func pull_action() -> void:
	var move_to = get_global_mouse_position()
	velocity = move_to * PULL_SPEED
