extends ProgressBar

@export var player_path: NodePath
@onready var player = get_node(player_path)

func _ready():
	min_value = 0
	max_value = player.max_health
	value = player.health

func _process(_delta):
	value = player.health
