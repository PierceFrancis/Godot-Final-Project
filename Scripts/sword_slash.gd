extends Node2D

#COLLISION: LAYER AND MASK ARE ON 2 ALL ENEMYS SHOULD BE ON 2. CHECK AREA 2D NODE

var weapon_damage: float = 1.0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		$Sprite2D/AnimationPlayer.play("slash")
	

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "slash":
		self.hide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		print("is enemy")
		body.take_damage(weapon_damage)
