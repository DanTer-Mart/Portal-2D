extends Node
static var LoadingSceneStatic: Node2D
@onready var loadingdescriptiontext: Label = $"LoadingScene/LoadingDescription"
@onready var loadingheaderlabel: Label = $"LoadingScene/Header"
@onready var progressbarloading: ProgressBar = $"LoadingScene/LoadingProgressBar"
static var LoadedScenes: Node2D

var scenesToLoad = [
	"res://Scenes/BuildScenes/Lobby/MainMenu.tscn",
	"res://Scenes/BuildScenes/Battle/BattleScene.tscn",
	"res://Scenes/BuildScenes/UI/Registration.tscn"
	]
	
static var currentsceneid = -1

var lobby: Node2D
var battlescene: Node2D
var server_check = false

func loadScenes():
	for i in range(scenesToLoad.size()):
		var v = scenesToLoad[i]
		var instance = load(v).instantiate()
		LoadedScenes.add_child(instance)
		instance.set_meta("scene_id", i)
	return true

func _ready() -> void:
	Engine.max_fps = 60
	LoadedScenes = $"LoadedScenes"
	LoadingSceneStatic = $"LoadingScene"

	await get_tree().create_timer(0.2).timeout
	
	loadingdescriptiontext.text = "Загрузка дополнительных сцен..."
	var tweenbar: Tween = create_tween()
	tweenbar.tween_property(progressbarloading, "value", 50, 0.25)
	tweenbar.set_trans(Tween.TRANS_SINE)
	tweenbar.set_ease(Tween.EASE_IN_OUT)
	tweenbar.play()
	
	loadScenes()
	await get_tree().create_timer(0.3).timeout
	
	loadingdescriptiontext.text = "Подключение к серверу..."
	var tweenbar2: Tween = create_tween()
	tweenbar2.tween_property(progressbarloading, "value", 95, 0.25)
	tweenbar2.set_trans(Tween.TRANS_SINE)
	tweenbar2.set_ease(Tween.EASE_IN_OUT)
	tweenbar2.play()
	
	NetworkHandlerNode.connectToServer()
	await NetworkHandlerNode.network_connected
	
	loadingdescriptiontext.text = "Подключено! Проверяю пакет.."
	var tweenbar4: Tween = create_tween()
	tweenbar4.tween_property(progressbarloading, "value", 99, 0.3)
	tweenbar4.set_trans(Tween.TRANS_SINE)
	tweenbar4.set_ease(Tween.EASE_IN_OUT)
	tweenbar4.play()
	
	await NetworkHandlerNode.server_check_passed
	
	await get_tree().create_timer(0.35).timeout
	loadingdescriptiontext.text = "Загружено!"
	loadingheaderlabel.text = "Ура!"
	var tweenbar3: Tween = create_tween()
	tweenbar3.tween_property(progressbarloading, "value", 100, 0.05)
	tweenbar3.set_trans(Tween.TRANS_SINE)
	tweenbar3.set_ease(Tween.EASE_IN_OUT)
	tweenbar3.play()

	await get_tree().create_timer(0.65).timeout
	LoadedScenes.visible = true
	LoadingSceneStatic.visible = false
	switchScene(0)

func _process(_delta: float) -> void:
	pass

static func find_node_with_metadata(root: Node, key: String, value: Variant):
	for child in root.get_children():
		if child.has_meta(key) and child.get_meta(key) == value:
			return child
		var found = find_node_with_metadata(child, key, value)
		if found:
			return found
	return null

static func hide_every_loaded_scene() -> void:
	for child: Node2D in LoadedScenes.get_children():
		if child.is_class("Node2D"):
			child.visible = false

static func switchScene(sceneid: int) -> void:
	if currentsceneid != sceneid:
		var node: Node2D = find_node_with_metadata(LoadedScenes, "scene_id", sceneid)
		if node:
			if node.is_class("Node2D"):
				currentsceneid = sceneid
				hide_every_loaded_scene()
				node.visible = true
