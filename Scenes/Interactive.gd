extends Area2D

var cubes: Array = [] # список кубов
var selected_cube: RigidBody2D = null # выбранный куб

func _ready() -> void:
	input_pickable = true # чтоб area2d получала события ввода

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
# левая кнопка мыши нажата
			if selected_cube == null:
# если куб не выбран, выбираем его
				var mouse_pos = get_global_mouse_position()
				var space_state = get_world_2d().direct_space_state
				var query = PhysicsPointQueryParameters2D.new()
				query.position = mouse_pos
				query.collide_with_bodies = true
				query.collide_with_areas = false

				var result = space_state.intersect_point(query)

				if result.size() > 0:
# куб найден
					var collider = result[0].collider
					if collider is RigidBody2D:
						selected_cube = collider
						selected_cube.gravity_scale = 0
						print("куб выбран")
					else:
						selected_cube = null
				else:
					print("куб не найден")
			else:
# если куб выбран, двигаем его
				var mouse_pos = get_global_mouse_position()
				selected_cube.apply_impulse((mouse_pos - selected_cube.global_position) * 10) # умножаем на 10 для силы
				if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
					selected_cube = null
					selected_cube.gravity_scale = 1
					print("куб отпущен")

func _body_entered(body: Node2D) -> void:
# добавляем куб в список
	if body is RigidBody2D:
		cubes.append(body)
		print("куб добавлен")

func _body_exited(body: Node2D) -> void:
# удаляем куб из списка
	if body is RigidBody2D:
		cubes.erase(body)
		print("куб удален")
