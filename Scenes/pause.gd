extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_resume_pressed() -> void:
	print("resume works")
	get_tree().paused = false
	visible = false


func _on_back_pressed() -> void:
	print("back works")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/levels_screen.tscn")

func _on_quit_pressed() -> void:
	print("quit works")
	get_tree().paused = false
	get_tree().quit()
