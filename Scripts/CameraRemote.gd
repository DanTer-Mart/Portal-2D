extends Camera2D

@export var player: Node2D
@export var offset1: Vector2 = Vector2(0, 0)

func _process(delta):
	global_position = player.global_transform.origin + offset1
	self.position = global_position
	# хули не двигается!!!!!!!
