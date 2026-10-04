extends CharacterBody2D

var speed = 350
var turn_left = false
var turn_right = false
@onready var animation = $AnimatedSprite2D

var bullet = preload("res://playerbullet.tscn")
var canshoot = true
var bullet_array = []
@onready var bulletmarker = $"Bullet Maker"

func _physics_process(delta: float) -> void:
	var movement = Vector2.ZERO
	play_animation()
	if Input.is_action_pressed("Up"):
		movement.y = -1
	if Input.is_action_pressed("Down"):
		movement.y = 1
	if Input.is_action_pressed("Left"):
		turn_left = true
		movement.x = -1
	else: turn_left = false
	if Input.is_action_pressed("Right"):
		turn_right = true
		movement.x = 1
	else: 	turn_right = false
	
	movement = movement.normalized() #Prevent player from moving faster diagonally
	velocity = movement * speed
	move_and_slide()
	
	var screen_size = get_viewport_rect().size
	var half_size = 16
	global_position.x = clamp(global_position.x, half_size, screen_size.x - half_size)
	global_position.y = clamp(global_position.y, 250, screen_size.y - half_size) #leave space for enemies to appear

func play_animation() -> void:
	if turn_left:
		animation.play("turn_left")
	elif turn_right:
		animation.play("turn_right")
	else:
		animation.play("default")


func _ready() -> void:
	var screen_size = get_viewport_rect().size
	global_position.x = screen_size.x/2
	global_position.y = screen_size.y/2 

	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("Shoot") and canshoot:
		shoot()
		print(bullet_array)
	


func _on_shooting_timer_timeout() -> void:
	canshoot = true	

func shoot():
	var new_bullet = bullet.instantiate()
	get_parent().add_child(new_bullet)
	bullet_array.append(new_bullet)
	
	new_bullet.position = bulletmarker.global_position

	
	$ShootingTimer.start()
	canshoot = false
