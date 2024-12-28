extends CharacterBody2D

# Скорость движения персонажа
var speed = 222
var pixer = "defaultDown"
# Задайте анимационный узел
@onready var animated_sprite = $Sprite
@export var camera: Camera2D

func _process(delta):
	velocity = Vector2.ZERO
	# Проверка ввода для движения
	if Input.is_action_pressed("w"):
		velocity.y -= 1
	if Input.is_action_pressed("s"):
		velocity.y += 1
	if Input.is_action_pressed("a"):
		velocity.x -= 1
	if Input.is_action_pressed("d"):
		velocity.x += 1

	# Нормализуем вектор скорости, чтобы избежать ускорения при диагональном движении
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

		# Определение анимации в зависимости от направления
		if velocity.y < 0:
			animated_sprite.play("Up")
			pixer = "defaultUp"
		elif velocity.y > 0:
			animated_sprite.play("Down")
			pixer = "defaultDown"
		elif velocity.x < 0:
			animated_sprite.play("Left")
			pixer = "defaultLeft"
		elif velocity.x > 0:
			animated_sprite.play("Right")
			pixer = "defaultRight"
	else:
		animated_sprite.stop()
		animated_sprite.play(str(pixer))
	# Движение персонажа
	move_and_slide()
