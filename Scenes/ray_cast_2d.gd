extends RayCast2D

var target  = null
@export var alert: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_colliding():
		if get_collider() == $"." :
			target = get_collider()
			alert = true
			
			
			
