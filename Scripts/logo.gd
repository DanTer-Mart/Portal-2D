extends Sprite2D

func _ready() -> void:
	var viewport_size = get_viewport().get_visible_rect().size
	var array = [$"../WhoIsAuthor",$".",$"../Portal2",$"../Portal1"] # циклы
	for i in array.size():
		array[i].position = viewport_size / 2
		if i > 1:
			array[i].position.x -= 200
			# да, я сам этот скрипт писал без ии!!
	position.y -= 750
	$"../Portal1".position.y += 475
	$"../Portal2".position.y -= 475


func _TOMenu() -> void:
	$AnimationLogo.play("end")
