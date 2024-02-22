extends Node2D

class_name Weapon

signal fired
signal reloading
signal reloaded

@export var bullet: PackedScene

@onready var barrel = $GunBarrel
@onready var sprite = $GunSprite

@export var reload_time:   float
@export var ammo_amount:   int = 0
@export var shots_amount:  int = 0
@export var shot_velocity: int = 0
@export var damage: 	   int = 0

@export var desired_range: float = 200

@export var min_spread:    	 float = 0
@export var spread: 	   	 float
@export var max_rand_spread: float
@export var max_spread:      float

@export var sprite_offset:	 int

@onready var team
var current_ammo
var is_reloading := false

signal bullet_fired(bullet, pos, direction)

func set_team(p_team):
	team = p_team

func _ready():
	current_ammo = ammo_amount
	pass

func reload():
	if !is_reloading:
		reloading.emit()
		is_reloading = true
		await get_tree().create_timer(reload_time).timeout
		current_ammo = ammo_amount
		is_reloading = false
		reloaded.emit()
		return
	elif is_reloading:
		return

func shoot():
	if is_reloading:
		return
	
	if current_ammo == 0:
		reload()
		return
	
	if $Cooldown.is_stopped() == false:
		return
	
	for i in shots_amount:
		var new_bullet = bullet.instantiate()
		var bullet_direction = (barrel.global_position - self.global_position - generate_bullet_spread()).normalized()
		GlobalShooting.bullet_fired.emit(new_bullet, barrel.global_position, bullet_direction, team, damage, shot_velocity)
	
	current_ammo -= 1
	
	$SpreadTimer.start()
	
	$Cooldown.start()
	fired.emit()

func generate_bullet_spread() -> Vector2:
	var bullet_spread := Vector2.ZERO
	
	spread += 0.05
	
	spread = clamp(spread, 0, max_spread - min_spread)
	
	var rand_spread = randf_range(-max_rand_spread, max_rand_spread)
	
	var spread_direction = randi_range(-1, 1)
	
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

