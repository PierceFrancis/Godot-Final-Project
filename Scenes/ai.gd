extends Node

@onready var player_detection_zone = $PlayerDetectionZone

signal state_changed(new_state)

enum State {
	IDLE,
	AIM,
	SHOOT
}


var current_state := State.IDLE:
	set(new_state):
		set_state(new_state)

func set_state(new_state: int):
	if new_state == current_state:
		return
		
	current_state = new_state
	emit_signal("state_changed",current_state)
