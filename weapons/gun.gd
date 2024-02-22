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
	add_child(new_bullet)
	new_bullet.global_position = barrel.global_position
	await get_tree().create_timer(0.001).timeout 
	new_bullet.set_direction(bullet_direction)
	$Cooldown.start()
	
	#global_shooting.bullet_fired.emit(new_bullet, barrel.global_position, bullet_direction)
