extends Node2D

var big := false
var _t := 0.0
var _dur := 0.35

func _ready() -> void:
	if big:
		_dur = 0.6

func _process(delta: float) -> void:
	_t += delta
	queue_redraw()
	if _t >= _dur:
		queue_free()

func _draw() -> void:
	var p := _t / _dur
	var r := (60.0 if big else 20.0) * p
	draw_circle(Vector2.ZERO, r, Color(1.0, 0.5, 0.1, 1.0 - p))
	draw_circle(Vector2.ZERO, r * 0.5, Color(1.0, 1.0, 0.6, 1.0 - p))
