extends Node2D

var velocity = Vector2()
var gravity: float = 2000
var jump_force: float = -800
var is_on_ground: bool = false
var is_jumping: bool = false
var health: int = 100
var is_dead: = false

@onready var player_animation = $PlayerAnimation/PlayerAnimation
@onready var health_bar = $HealthBar
@onready var game_over_label = $CanvasLayer/GameOver
@onready var dark_overlay = $CanvasLayer/DarkOverlay

func _ready() -> void:
	health = 100
	health_bar.init_health(health)
	game_over_label.visible = false
	dark_overlay.visible = false
	is_dead = false

func _process(delta: float) -> void:
	if is_dead:
		return
		
	if Input.is_action_pressed("right"):
		player_animation.position += Vector2(1, 0) * 400 * delta
		player_animation.flip_h = false
		if not is_jumping:
			player_animation.play("move")
	elif Input.is_action_pressed("left"):
		player_animation.position += Vector2(1, 0) * -400 * delta
		player_animation.flip_h = true
		if not is_jumping:
			player_animation.play("move")
	elif not is_jumping:
		velocity.x = 0
		player_animation.play("idle")
		
	if Input.is_action_pressed("jump") and is_on_ground:
		velocity.y = jump_force
		player_animation.play("jump")
		$JumpSound.play()
		is_jumping = true

	# Testing health decrease with the "H" key
	if Input.is_action_just_pressed("H"):
		health -= 10
		health_bar._set_health(health)
		$HitSound.play()

	# Check if health is 0 or below
	if health <= 0:

		show_game_over()

	# Apply gravity
	velocity.y += gravity * delta

	# Update position
	player_animation.position.y += velocity.y * delta

	# Check if the character is on the ground
	if player_animation.position.y >= 678:
		player_animation.position.y = 678
		velocity.y = 0
		is_on_ground = true
		is_jumping = false
	else:
		is_on_ground = false

func show_game_over() -> void:
	is_dead = true
	health = 1
	# Show the dark overlay and game over label
	dark_overlay.visible = true
	game_over_label.visible = true
	$DieSound.play()

	# Optionally, add fade-in effect or animation to the label here
	# Example: game_over_label.modulate.a = 0 and animate to 1

	# Start a timer to restart the game after 2 seconds
	var timer = Timer.new()
	timer.wait_time = 2.0
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_on_timeout"))  # Use Callable for connecting signals
	add_child(timer)
	timer.start()

func _on_timeout() -> void:
	get_tree().reload_current_scene()
