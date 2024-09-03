extends Area2D

@onready var timer: Timer = $Timer
@onready var die_sound: AudioStreamPlayer = %DieSound
@onready var game_manager: Node = %GameManager


	

func _on_body_entered(body) -> void:
	game_manager.show_game_over()
