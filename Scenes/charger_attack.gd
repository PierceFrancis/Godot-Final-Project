extends Node2D
var weapon_damage: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "thrust":
		print("i shuld ave attacjecd")
		self.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("attacking player")
		#body.take_damage(weapon_damage)
