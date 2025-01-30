extends CharacterBody2D

var speed = 200  # Скорость движения
var jump_force = -400  # Сила прыжка
var gravity = 800  # Гравитация

func _process(delta):
	velocity.y += gravity * delta  # Применяем гравитацию

	if Input.is_action_pressed("a"):  # Проверяем нажатие клавиши A или стрелки влево
		velocity.x = -speed
	elif Input.is_action_pressed("d"):  # Проверяем нажатие клавиши D или стрелки вправо
		velocity.x = speed
	else:
		velocity.x = 0
	if Input.is_action_just_pressed("w") and is_on_floor():  # Проверяем нажатие клавиши W или пробела для прыжка
		velocity.y = jump_force

	move_and_slide()
