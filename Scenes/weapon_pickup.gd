extends Area2D

signal picked_up

var player_inside: Node = null  # reference to the player currently inside

func _ready() -> void:
	var manager = get_tree().root.get_node("/root/GameManager") # adjust if needed
	self.picked_up.connect(manager.weaponUp)


func _on_body_entered(body: Node) -> void:	
	if body.is_in_group("Player"):
		print("Entered")
		player_inside = body

func _on_body_exited(body: Node) -> void:
	
	if body == player_inside:
		print("Exited")
		player_inside = null

func _process(_delta: float) -> void:
	if player_inside:
		if player_inside.is_in_group("Player") and Input.is_action_just_pressed("action_button") and GameManager.weapon != true:
			picked_up.emit(true)
			queue_free()
	
