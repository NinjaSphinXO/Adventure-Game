extends Node2D

var velocity: = Vector2()
var gravity:  = 2000 # Gravity value
var jump_force: = -800 # The force applied when jumping
var is_on_ground: = false # To check if the character is on the ground

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if Input.is_action_pressed("right"):
		velocity.x = 400
		$PlayerIdle.flip_h = false
	elif Input.is_action_pressed("left"):
		velocity.x = -400
		$PlayerIdle.flip_h = true
	else:
		velocity.x = 0 

	if Input.is_action_pressed("jump") and is_on_ground:
		velocity.y = jump_force
		$JumpSound.play()
	
	# Apply gravity
	velocity.y += gravity * delta

	# Update position
	position += velocity * delta

	# Check if the character is on the ground
	if position.y >= 305:
		position.y = 305
		velocity.y = 0
		is_on_ground = true
	else:
		is_on_ground = false
