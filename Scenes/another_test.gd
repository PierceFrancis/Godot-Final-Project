extends Node2D

@onready var crossbowman = $Crossbowman
@onready var arrow_manager = $ArrowManager
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	crossbowman.enemy_shot_arrow.connect(arrow_manager.handle_arrow_spawned)
