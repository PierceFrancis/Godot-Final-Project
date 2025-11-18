extends Node2D

var weapon_damage: float = 1.0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		$Sprite2D/AnimationPlayer.play("slash")
	

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "slash":
		queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.take_damage(weapon_damage)
