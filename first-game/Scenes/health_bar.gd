extends ProgressBar

var health: int

func _set_health(new_health):
	var prev_health = health
	health = min(max_value,new_health)
	value = health
	
	if health <= 0:
		queue_free()
		
	if health < prev_health:
		$Timer.start()
	else:
		$DamageBar.value = health	
	
func init_health(_health):
	health = _health
	max_value = health
	value = health
	$DamageBar.max_value = health
	$DamageBar.value = health


func _on_timer_timeout() -> void:
	$DamageBar.value = health
