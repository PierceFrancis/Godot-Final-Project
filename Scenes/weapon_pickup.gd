extends Area2D

signal picked_up

var player_inside: Node = null  # reference to the player currently inside
@onready var prompt_label = $PickupPrompt  # Label child that displays "E"

func _ready() -> void:
	var manager = get_tree().root.get_node("/root/GameManager") # adjust if needed
	self.picked_up.connect(manager.weaponUp)

	if prompt_label:
		prompt_label.visible = false  # hide prompt by default

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		print("Entered weapon pickup area")
		player_inside = body
		if prompt_label:
			prompt_label.visible = true  # show "E" prompt

func _on_body_exited(body: Node) -> void:
	if body == player_inside:
		print("Exited weapon pickup area")
		player_inside = null
		if prompt_label:
			prompt_label.visible = false  # hide prompt

func _process(_delta: float) -> void:
	if player_inside:
		if Input.is_action_just_pressed("action_button") and GameManager.weapon != true:
			picked_up.emit(true)
			queue_free()
