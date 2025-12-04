extends Node2D

@export var speed: float = 1500.0
@export var pickup_made: PackedScene = preload("res://Scenes/weapon_pickup.tscn")
 
var weapon_damage: float = 1.0
var direction: Vector2 = Vector2.ZERO
var ignore_body: Node = null

func _ready() -> void:
	$slash/AnimationPlayer.play("flying")
	$slash2/AnimationPlayer.play("flying2")
	
	
	connect("body_entered", Callable(self, "_on_body_entered"))
	# Optional: auto-despawn after 2 seconds
	await get_tree().create_timer(1.0).timeout
	if is_inside_tree():
		_spawn_pickup()
		queue_free()


func _physics_process(delta: float) -> void:
	position += direction * speed * delta



func _spawn_pickup() -> void:
	if not pickup_made:
		return
	var pickup = pickup_made.instantiate()
	get_tree().root.add_child(pickup)
	pickup.global_position = global_position


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == ignore_body:
		return
	if body.is_in_group("enemy"):
		# Example: reduce health, trigger effect, etc.
		body.take_damage(weapon_damage)
		print("Hit enemy:", body.name)
		_spawn_pickup()
		queue_free()
	else:
		_spawn_pickup()
		queue_free()
