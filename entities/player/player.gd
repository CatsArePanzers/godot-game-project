extends CharacterBody2D

class_name Player

@onready var gun   		= $Gun
@onready var barrel     = $Gun/GunBarrel
@onready var gun_sprite = $Gun/GunSprite

@onready var animations = $AnimationPlayer
@onready var sprite 	= $PlayerSprite

@export var speed: 	int = 5
@export var health: int = 100

func _ready():
	pass

func _physics_process(_delta):
	velocity = Vector2.ZERO
	
	if Input.is_action_pressed("move_up"):
		velocity.y = -1;
	if Input.is_action_pressed("move_down"):
		velocity.y = 1
	if Input.is_action_pressed("move_left"):
		velocity.x = -1
	if Input.is_action_pressed("move_right"):
		velocity.x = 1
	
	velocity = velocity.normalized()
	move_and_collide(velocity * speed)
	move_and_slide()
	
	animate()

func _unhandled_input(event):
	if event.is_action_released("shoot"):
		gun.shoot()
	pass


func animate():
	if velocity == Vector2.ZERO:
		animations.play("idle")
	else: 
		animations.play("run")
		
	var mouse_pos = get_global_mouse_position()
	
	gun.look_at(mouse_pos)
	
	if mouse_pos.x - global_position.x < 0:
		gun_sprite.flip_v = true
		gun_sprite.offset = Vector2(0, -2)
		sprite.flip_h = true
	else:
		gun_sprite.flip_v = false
		gun_sprite.offset = Vector2(0, 2)
		$PlayerSprite.flip_h = false

func take_damage(damage):
	health -= damage
	if health <= 0:
		queue_free()
