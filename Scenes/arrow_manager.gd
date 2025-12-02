extends Node2D


func handle_arrow_spawned(arrow,position,direction):
	add_child(arrow)
	arrow.global_position = position
	arrow.set_direction(direction)
	
