extends CanvasLayer

@export var player_path: NodePath
@export var health_hud_path: NodePath

@onready var player = get_node(player_path)
@onready var health_hud = get_node(health_hud_path)
@onready var overlay: Control = $Overlay

func _ready() -> void:
	overlay.hide()
	player.died.connect(_on_player_died)

func _on_player_died() -> void:
	health_hud.refresh()
	overlay.show()
	_stop_animations(get_parent())
	get_tree().paused = true

func _stop_animations(node: Node) -> void:
	if node is AnimatedSprite2D:
		node.stop()
	elif node is AnimationPlayer:
		node.pause()
	for child in node.get_children():
		_stop_animations(child)
