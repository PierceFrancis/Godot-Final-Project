extends CanvasLayer

# --- CONFIGURATION ---
@export var bar_increase_rate: float = 35.0   # how fast the bar recharges
@export var cooldown_color := Color(0.3, 0.3, 0.3, 0.6)  # dim color during cooldown
@export var normal_color := Color(1, 1, 1, 1)            # normal color when ready

# --- INTERNAL STATE ---
var is_on_cooldown: bool = false

@onready var texture_progress: TextureProgressBar = $TextureProgressBar
@onready var label: Label = $Label
@onready var label2: Label = $Label2

func _ready() -> void:
	texture_progress.value = 100.0
	texture_progress.modulate = normal_color


func _process(delta: float) -> void:
	# Debug UI text
	label2.text = "Health: " + str(GameManager.lives)

	# Handle recharge
	if is_on_cooldown:
		texture_progress.value += bar_increase_rate * delta

		if texture_progress.value >= 100.0:
			texture_progress.value = 100.0
			is_on_cooldown = false
			texture_progress.modulate = normal_color  # back to normal color


func _input(event):
	if event.is_action_pressed("dash") and not is_on_cooldown:
		# Trigger dash and cooldown
		texture_progress.value = 0.0
		is_on_cooldown = true
		texture_progress.modulate = cooldown_color  # dim bar to indicate cooldown
		

func _on_pause_pressed() -> void:
	get_tree().paused = true
	$Pause.visible = true
