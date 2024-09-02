extends Node2D

var velocity: = Vector2()
var gravity:  = 2000 # Gravity value
var jump_force: = -800 # The force applied when jumping
var is_on_ground: = false # To check if the character is on the ground
var is_jumping: = false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if Input.is_action_pressed("right"):
		position += Vector2(1,0) * 400 * delta
		$PlayerAnimation.flip_h = false
		if not is_jumping:
			$PlayerAnimation.play("move")
		
	elif Input.is_action_pressed("left"):
		position += Vector2(1,0) * -400 * delta
		$PlayerAnimation.flip_h = true
		if not is_jumping:
			$PlayerAnimation.play("move")
	elif not is_jumping:
		velocity.x = 0
		$PlayerAnimation.play("idle")
		
	if Input.is_action_pressed("jump") and is_on_ground:
		velocity.y = jump_force
		$PlayerAnimation.play("jump")
		$JumpSound.play()
		is_jumping = true

	
	# Apply gravity
	velocity.y += gravity * delta

	# Update position
	position += velocity * delta

	# Check if the character is on the ground
	if position.y >= 305:
		position.y = 305
		velocity.y = 0
		is_on_ground = true
		is_jumping = false

	else:
		is_on_ground = false
