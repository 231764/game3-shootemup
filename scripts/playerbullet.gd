extends Area2D

var speed = 450

func _physics_process(delta: float) -> void:
	# Move along the global Y-axis
	global_position.y -= speed * delta
	
	# Delete bullet once out of the screen
	if global_position.y < 0: 
		queue_free()
