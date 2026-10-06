extends Node2D

@export var enemy_scene: PackedScene
@export var spawn_interval := 1.2
@export var margin := 60.0

func _ready() -> void:
	var timer := Timer.new()
	timer.wait_time = spawn_interval
	timer.autostart = true
	timer.timeout.connect(_spawn)
	add_child(timer)

func _spawn() -> void:
	if enemy_scene == null:
		return
	var vp := get_viewport_rect().size
	var e = enemy_scene.instantiate()
	e.position = Vector2(randf_range(margin, vp.x - margin), -60.0)
	get_parent().add_child(e)
