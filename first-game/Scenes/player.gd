# player.gd

extends Node2D

var velocity = Vector2()
var gravity: float = 2000
var jump_force: float = -800
var is_on_ground: bool = false
var is_jumping: bool = false
var is_hit: bool = false

@onready var player_animation: AnimatedSprite2D = %PlayerAnimation
@onready var health_bar: ProgressBar = %HealthBar
@onready var hit_sound: AudioStreamPlayer = %HitSound
@onready var jump_sound: AudioStreamPlayer = %JumpSound


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if Global.inputs_frozen:
		return
		
	if Input.is_action_pressed("right"):
		player_animation.position += Vector2(1, 0) * 400 * delta
		player_animation.flip_h = false
		if not is_jumping and not is_hit:
			player_animation.play("move")
	elif Input.is_action_pressed("left"):
		player_animation.position += Vector2(1, 0) * -400 * delta
		player_animation.flip_h = true
		if not is_jumping and not is_hit:
			player_animation.play("move")
	elif not is_jumping and not is_hit:
		velocity.x = 0
		player_animation.play("idle")
		
	if Input.is_action_pressed("jump") and is_on_ground:
		velocity.y = jump_force
		player_animation.play("jump")
		jump_sound.play()
		is_jumping = true

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
	

func apply_hit() -> void:
	is_hit = true
	player_animation.play("hit")
	hit_sound.play()

	var timer2 = Timer.new()
	timer2.wait_time = 0.2
	timer2.one_shot = true
	timer2.connect("timeout", Callable(self, "_on_timeout2"))  # Use Callable for connecting signals
	add_child(timer2)
	timer2.start()

func _on_timeout2() -> void:
	is_hit = false
