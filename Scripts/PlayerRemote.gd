extends CharacterBody2D

var speed = 200  # Скорость движения
var jump_force = -400  # Сила прыжка
var gravity = 800  # Гравитация

func _physics_process(delta: float) -> void:
	# гравитация
	if not is_on_floor():
		velocity.y += gravity * delta
	var direction: float = Input.get_action_strength("d") - Input.get_action_strength("a")
	velocity.x = direction * speed
	if Input.is_action_just_pressed("w") and is_on_floor():  # Проверяем нажатие клавиши W или пробела для прыжка
		velocity.y = jump_force
	move_and_slide()  # Применяем движение с учетом коллизии
