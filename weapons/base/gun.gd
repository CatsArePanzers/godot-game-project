extends Node2D

class_name Weapon

@export var bullet: PackedScene

@onready var barrel = $GunBarrel
@onready var sprite = $GunSprite

@export var shot_velocity: int = 0
@export var damage: 	   int = 0

@export var min_spread:    float
@export var spread: 	   float
@export var max_spread:    float

@export var offset:		   int

@onready var team

signal bullet_fired(bullet, pos, direction)

func set_team(p_team):
	team = p_team

func _ready():
	pass

func shoot():
	if $Cooldown.is_stopped() == false:
		return
	
	var new_bullet = bullet.instantiate()
	var bullet_direction = (barrel.global_position - self.global_position - generate_bullet_spread()).normalized()
	GlobalShooting.bullet_fired.emit(new_bullet, barrel.global_position, bullet_direction, team, damage, shot_velocity)
	$Cooldown.start()
	
	$SpreadTimer.start()

func generate_bullet_spread() -> Vector2:
	var bullet_spread := Vector2.ZERO
	
	spread += 0.05
	
	spread = clamp(spread, 0, max_spread - min_spread)
	
	var rand_spread = randf_range(-1, 1)
	
	var spread_direction = randi_range(-1, 1)
	
	while spread_direction == 0:
		spread_direction = randi_range(-1, 1)
	
	if abs(fmod(global_rotation, PI * 3/4)) < PI/4:
		bullet_spread.y = min_spread + spread
		bullet_spread.y += rand_spread
	else:
		bullet_spread.x = min_spread + spread
		bullet_spread.x += rand_spread
	
	bullet_spread *= spread_direction
	
	return bullet_spread

func _on_spread_timer_timeout():
	spread = 0

