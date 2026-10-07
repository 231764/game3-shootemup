extends Control

@export var player_path: NodePath
@onready var player = get_node(player_path)
@onready var health_label: Label = $HealthLabel

const SEGMENTS := 10
const BAR_X := 80.0
const BAR_WIDTH := 240.0
const BAR_HEIGHT := 18.0
const TRACK_COLOR := Color(0.04, 0.07, 0.13, 0.82)
const BORDER_COLOR := Color(0.6, 0.78, 0.68, 0.95)
const EMPTY_COLOR := Color(0.1, 0.18, 0.16, 0.95)
const FULL_COLOR := Color(0.22, 0.8, 0.37, 0.96)
const HIGHLIGHT_COLOR := Color(0.48, 0.94, 0.57, 0.96)

var _health := -1
var _max_health := 1

func _ready() -> void:
	_update_health()

func _process(_delta: float) -> void:
	_update_health()

func refresh() -> void:
	_update_health()

func _update_health() -> void:
	if not is_instance_valid(player):
		return
	var next_max := maxi(int(player.max_health), 1)
	var next_health := clampi(int(player.health), 0, next_max)
	if next_health == _health and next_max == _max_health:
		return
	_health = next_health
	_max_health = next_max
	health_label.text = "HP %d/%d" % [_health, _max_health]
	queue_redraw()

func _draw() -> void:
	var track := Rect2(BAR_X, 0.0, BAR_WIDTH, BAR_HEIGHT)
	draw_rect(track, TRACK_COLOR)
	var filled_count := clampi(ceili(float(_health) / _max_health * SEGMENTS), 0, SEGMENTS)
	for i in range(SEGMENTS):
		var x := BAR_X + 2.0 + i * 24.0
		var segment := Rect2(x, 2.0, 20.0, 14.0)
		if i < filled_count:
			draw_rect(segment, FULL_COLOR)
			draw_rect(Rect2(x, 2.0, 20.0, 2.0), HIGHLIGHT_COLOR)
		else:
			draw_rect(segment, EMPTY_COLOR)
	draw_rect(track, BORDER_COLOR, false, 1.0)
