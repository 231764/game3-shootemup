extends Area2D

@export var speed := 350.0
@export var damage := 1
@export var explosion_scene: PackedScene

var direction := Vector2.DOWN

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	position += direction * speed * delta
	var h := get_viewport_rect().size.y
	if position.y > h + 50.0 or position.y < -100.0:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
		if explosion_scene:
			var e = explosion_scene.instantiate()
			e.big = false
			e.global_position = global_position
			get_tree().current_scene.add_child(e)
		queue_free()
