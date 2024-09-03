# game_manager.gd

extends Node

@onready var game_over:  = %GameOver
@onready var health_bar:  = %HealthBar
@onready var die_sound:  = %DieSound
@onready var hit_sound:  = %HitSound
@onready var player: = %Player.get_node("PlayerAnimation")

var is_dead: bool
var health: int
var global_player_position: Vector2
var previous_position: Vector2

func update_health_bar_position() -> void:
	if not is_dead:
		var current_position = player.global_position
		var delta_position = current_position - previous_position
		health_bar.global_position += delta_position
		previous_position = current_position

func _ready() -> void:
	previous_position = player.global_position
	is_dead = false
	health = 100
	health_bar.init_health(health)
	game_over.get_node("Label").visible = false
	game_over.get_node("DarkOverlay").visible = false

func show_game_over() -> void:
	is_dead = true
	health = 1
	# Show the dark overlay and game over label
	game_over.get_node("Label").visible = true
	game_over.get_node("DarkOverlay").visible = true
	die_sound.play()

	var timer = Timer.new()
	timer.wait_time = 2.0
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_on_timeout"))  # Use Callable for connecting signals
	add_child(timer)
	timer.start()

func _on_timeout() -> void:
	get_tree().reload_current_scene()
	Global.inputs_frozen = false

func _process(delta: float) -> void:
	if is_dead:
		Global.inputs_frozen = true
		return
		
	if health <= 0:
		show_game_over()
		
	if Input.is_action_just_pressed("H"):
		apply_hit()
	update_health_bar_position()

func apply_hit() -> void:
	health -= 10
	health_bar._set_health(health)
	

	player.apply_hit()
