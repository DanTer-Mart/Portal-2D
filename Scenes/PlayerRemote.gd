extends CharacterBody2D

func _physics_process(delta):
	velocity = Vector2.ZERO
	# Нормализуем вектор скорости, чтобы избежать ускорения при диагональном движении
	if velocity.length() > 0:
		velocity = velocity.normalized()
