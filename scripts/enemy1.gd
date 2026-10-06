extends Area2D

@export var max_health := 2
@export var speed := 150.0
@export var contact_damage := 1   # damage dealt to the player on collision
@export var ram_damage := 1       # damage the enemy takes when it hits the player
@export var explosion_scene: PackedScene

var health: int
var dead := false

func _ready() -> void:
	health = max_health
	add_to_group("enemy")
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	position.y += speed * delta
	if position.y > get_viewport_rect().size.y + 100.0:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if dead:
		return
	if area.is_in_group("player_bullet"):
		var dmg = area.get("damage")
		if dmg == null:
			dmg = 1
		_explode(area.global_position, false)
		area.queue_free()
		take_damage(dmg)

func _on_body_entered(body: Node2D) -> void:
	if dead:
		return
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(contact_damage)
		take_damage(ram_damage)

func take_damage(amount: int) -> void:
	if dead:
		return
	health -= amount
	if health <= 0:
		dead = true
		_explode(global_position, true)   # big explosion on destroy
		queue_free()

func _explode(pos: Vector2, big: bool) -> void:
	if explosion_scene == null:
		return
	var e = explosion_scene.instantiate()
	e.big = big
	e.global_position = pos
	get_tree().current_scene.add_child(e)
