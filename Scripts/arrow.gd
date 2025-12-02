extends Area2D
class_name  Arrow

@onready var kill_timer = $KillTimer


@export var speed : int = 200
var direction =Vector2.ZERO

func set_direction(direction: Vector2):
	self.direction = direction
	rotation += direction.angle()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	kill_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void: 
	if direction != Vector2.ZERO:
		var velocity = direction * speed
		global_position += velocity




func _on_kill_timer_timeout() -> void:
	queue_free()
	


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("handle_hit"):
		body.handle_hit()
