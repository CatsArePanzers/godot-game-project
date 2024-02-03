extends Node2D

@export var Bullet: PackedScene

@onready var barrel     = $GunBarrel
@onready var gun_sprite = $GunSprite

signal bullet_fired(bullet, pos, direction)

func _ready():
	pass

func shoot():
	if $Cooldown.is_stopped() == false:
		return
	
	var new_bullet = preload("res://weapons/bullet.tscn").instantiate()
	var bullet_direction = (barrel.global_position - self.global_position).normalized()
	GlobalShooting.bullet_fired.emit(new_bullet, barrel.global_position, bullet_direction, get_parent().team.team)
	$Cooldown.start()
	
