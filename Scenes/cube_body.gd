extends RigidBody2D
func _integrate_forces(state):
	print("Скорость объекта: ", state.linear_velocity)  # Отладочный вывод
