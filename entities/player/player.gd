extends CharacterBody2D

class_name Player

@onready var gun   		= $Gun
@onready var barrel     = $Gun/GunBarrel
@onready var gun_sprite = $Gun/GunSprite

@onready var animations = $AnimationPlayer
@onready var sprite 	= $PlayerSprite

@onready var team		= $Team

@export var speed: 	float = 5
@export var health: int = 1

var can_move_up:    bool = true
var can_move_down:	bool = true
var can_move_left:	bool = true
var can_move_right: bool = true

func get_camera():
	return $Camera

func get_team():
	return team.team

func _ready():
	pass

func _physics_process(_delta):
	velocity = Vector2.ZERO
	
	if Input.is_action_pressed("move_up") and can_move_up:
		velocity.y = -1;
	if Input.is_action_pressed("move_down") and can_move_down:
		velocity.y = 1
	if Input.is_action_pressed("move_left") and can_move_left:
		velocity.x = -1
	if Input.is_action_pressed("move_right")and can_move_right:
		velocity.x = 1
	
	velocity = velocity.normalized() * speed
	move_and_slide()
	
	animate()

func _unhandled_input(event):
	if event.is_action_released("shoot"):
		gun.shoot()

func animate():
	if velocity == Vector2.ZERO:
		animations.play("idle")
	else: 
		animations.play("run")
	
	var mouse_pos = get_global_mouse_position()
	
	gun.look_at(mouse_pos)
	
	if barrel.global_position.x - global_position.x < 0:
		gun_sprite.flip_v = true
		gun_sprite.offset = Vector2(0, -2)
		sprite.flip_h = true
	else:
		gun_sprite.flip_v = false
		gun_sprite.offset = Vector2(0, 2)
		sprite.flip_h = false

func take_damage(damage):
	health -= damage
	if health <= 0:
		queue_free()
