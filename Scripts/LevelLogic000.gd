extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_PrefabCubeactive() -> void:
	$PrefabCube/StaticBody2D.set_collision_layer(0)
	$PrefabCube/StaticBody2D.set_collision_mask(0)
	$PrefabCube.frame = 1
	
func _on_PrefabCubedeactive() -> void:
	$PrefabCube/StaticBody2D.set_collision_layer(1)
	$PrefabCube/StaticBody2D.set_collision_mask(1)
	$PrefabCube.frame = 0
