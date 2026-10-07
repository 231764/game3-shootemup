extends Node2D

@export_range(20, 300, 1) var star_count := 120
@export_range(10.0, 200.0, 1.0) var scroll_speed := 55.0

const SPACE_COLOR := Color(0.015, 0.025, 0.075)
const COOL_STAR := Color(0.75, 0.85, 1.0)
const WARM_STAR := Color(1.0, 0.85, 0.67)

var _rng := RandomNumberGenerator.new()
var _stars: Array[Dictionary] = []
var _viewport_size: Vector2

func _ready() -> void:
	_rng.randomize()
	_viewport_size = get_viewport_rect().size
	_create_stars()

func _process(delta: float) -> void:
	var new_size := get_viewport_rect().size
	if new_size != _viewport_size:
		_viewport_size = new_size
		_create_stars()

	for star in _stars:
		var position: Vector2 = star["position"]
		position.y += star["speed"] * delta
		if position.y > _viewport_size.y:
			position = Vector2(_rng.randf_range(0.0, _viewport_size.x), -star["length"])
		star["position"] = position
	queue_redraw()

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, _viewport_size), SPACE_COLOR)
	for star in _stars:
		var position: Vector2 = star["position"]
		var width: float = star["width"]
		var length: float = star["length"]
		var color: Color = star["color"]
		draw_rect(Rect2(position.round(), Vector2(width, length)), color)

func _create_stars() -> void:
	_stars.clear()
	for _i in range(star_count):
		var depth := _rng.randf()
		var width := 2.0 if depth < 0.6 else (4.0 if depth < 0.9 else 6.0)
		var length := width if depth < 0.9 else width * (1.0 + _rng.randf())
		var color := WARM_STAR if _rng.randf() < 0.1 else COOL_STAR
		color.a = lerpf(0.35, 0.9, depth)
		_stars.append({
			"position": Vector2(_rng.randf_range(0.0, _viewport_size.x), _rng.randf_range(0.0, _viewport_size.y)),
			"speed": scroll_speed * lerpf(0.35, 1.8, depth),
			"width": width,
			"length": length,
			"color": color,
		})
	queue_redraw()
