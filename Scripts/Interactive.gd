extends Area2D

var grabbed_body: RigidBody2D = null
var grab_offset := Vector2.ZERO
var grab_strength := 15000.0  # Увеличил силу до уровня реактивного двигателя
@onready var collision_shape := $CollisionShape2D

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_pos = get_global_mouse_position()

		if event.pressed:
			var space = get_world_2d().direct_space_state
			var query = PhysicsPointQueryParameters2D.new()
			query.position = mouse_pos

			var result = space.intersect_point(query)
			for col in result:
				if col.collider is RigidBody2D:
# Проверяем через прямое перекрытие
					if self.overlaps_body(col.collider):  # Вот правильный метод!
						grab_offset = col.collider.global_position - mouse_pos
						grabbed_body = col.collider
						break
		else:
			if grabbed_body:
				grabbed_body.gravity_scale = 1.0
				grabbed_body = null

func _physics_process(delta):
	if grabbed_body:
		var mouse_pos = get_global_mouse_position()
		var target_pos = mouse_pos + grab_offset
		# Жёсткая фиксация позиции
		grabbed_body.global_transform.origin = target_pos
		grabbed_body.angular_velocity = 0
		grabbed_body.linear_velocity = Vector2.ZERO
# Для дебага визуализация зоны
func _draw():
	if collision_shape:
		draw_rect(collision_shape.shape.get_rect(), Color.RED, false)
