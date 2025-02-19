extends Sprite2D

func _ready() -> void:
	var viewport_size = get_viewport().get_visible_rect().size
	position = viewport_size / 2
	position.x -= 200
	$"../Label".position = viewport_size / 2
