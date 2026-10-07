extends Area2D

@export var max_health := 3
@export var enter_speed := 150.0     # speed while dropping in from the top
@export var hover_y := 120.0         # height where it stops and starts hovering
@export var sway_amplitude := 200.0  # how far it moves left and right
@export var sway_speed := 1.5
@export var fire_interval := 1.2
@export var contact_damage := 1
@export var ram_damage := 1
@export var bullet_scene: PackedScene
@export var explosion_scene: PackedScene
@onready var animation = $Sprite2D

var health: int
var dead := false
var _hovering := false
var _t := 0.0
var _center_x := 0.0
var _shoot_timer: Timer

func _ready() -> void:
	animation.play("default")
	health = max_health
	add_to_group("enemy")
	_center_x = clamp(position.x, sway_amplitude, get_viewport_rect().size.x - sway_amplitude)
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)

	_shoot_timer = Timer.new()
	_shoot_timer.wait_time = fire_interval
	_shoot_timer.autostart = false
	_shoot_timer.timeout.connect(_shoot)
	add_child(_shoot_timer)

func _process(delta: float) -> void:
	if not _hovering:
		position.y += enter_speed * delta
		if position.y >= hover_y:
			position.y = hover_y
			_hovering = true
			_shoot_timer.start()
	else:
		_t += delta
		position.x = _center_x + sin(_t * sway_speed) * sway_amplitude

func _shoot() -> void:
	if dead or bullet_scene == null:
		return
	var b = bullet_scene.instantiate()
	b.global_position = global_position + Vector2(0, 30)
	b.direction = Vector2.DOWN
	get_parent().add_child(b)

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
		_explode(global_position, true)
		queue_free()

func _explode(pos: Vector2, big: bool) -> void:
	if explosion_scene == null:
		return
	var e = explosion_scene.instantiate()
	e.big = big
	e.global_position = pos
	get_tree().current_scene.add_child(e)
