extends CharacterBody2D

@onready var ai  = $AI

@onready var gun   		= $Gun
@onready var barrel     = $Gun/GunBarrel
@onready var gun_sprite = $Gun/GunSprite

@onready var animations = $AnimationPlayer
@onready var sprite 	= $EnemySprite

@export var speed: int = 3

var direction = Vector2.ZERO
var target = null

@export var health: int = 100

func _ready():
	ai.set_weapon(gun)
	ai.connect("emit_target", self.set_target)
	animate()

func set_target(new_target):
	target = new_target

func _physics_process(_delta):
	if target:
		direction = global_position.direction_to(target.global_position)
	else: 
		direction = Vector2.ZERO
	
	move_and_collide(direction * speed)
	
	animate()

func animate():
	if direction == Vector2.ZERO:
		animations.play("idle")
	else: 
		animations.play("run")
	
	if barrel.global_position.x - self.global_position.x < 0:
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
