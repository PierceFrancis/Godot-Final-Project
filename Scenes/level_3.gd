extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.current_level_path = scene_file_path


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
