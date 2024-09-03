extends CharacterBody2D

@onready var player: AnimatedSprite2D = %PlayerAnimation
@onready var hit_sound: AudioStreamPlayer = %HitSound
@onready var jump_sound: AudioStreamPlayer = %JumpSound
@onready var die_sound: AudioStreamPlayer = %DieSound
@onready var timer: Timer = $Timer

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var is_hit: bool = false


func _physics_process(delta: float) -> void:
	if Global.inputs_frozen:
		return

	
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump_sound.play()
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("left", "right")
	
	if not is_hit:
		if is_on_floor():
			if direction == 0:
				player.play("idle")
			else:
				player.play("move")
		else:
			player.play("jump")	
	else:
		player.play("hit")
	
	if direction > 0:
		player.flip_h = false
	elif direction < 0:
		player.flip_h = true

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func apply_hit() -> void:
	if timer.time_left <= 0:
		is_hit = true
		hit_sound.play()
		timer.start()
	
	



func _on_timer_timeout() -> void:
	is_hit = false
