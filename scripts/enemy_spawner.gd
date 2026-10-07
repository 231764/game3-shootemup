extends Node2D

@export var enemy_scene: PackedScene     # enemy1 (falls down)
@export var enemy2_scene: PackedScene    # enemy2 (hover and shoot)
@export var spawn_interval := 1.2
@export_range(0.0, 1.0) var enemy2_chance := 0.3
@export var margin := 250.0

func _ready() -> void:
	var timer := Timer.new()
	timer.wait_time = spawn_interval
	timer.autostart = true
	timer.timeout.connect(_spawn)
	add_child(timer)

func _spawn() -> void:
	var vp := get_viewport_rect().size
	var scene: PackedScene = enemy_scene
	var x := randf_range(60.0, vp.x - 60.0)
	if enemy2_scene and randf() < enemy2_chance:
		scene = enemy2_scene
		x = randf_range(margin, vp.x - margin)
	if scene == null:
		return
	var e = scene.instantiate()
	e.position = Vector2(x, -60.0)
	get_parent().add_child(e)
