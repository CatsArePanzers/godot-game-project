extends Node2D

func _ready():
	GlobalShooting.bullet_fired.connect(handle_bullet)

func handle_bullet(bullet: Bullet, pos, direction, team, damage, speed):
	bullet.global_position = pos
	bullet.rotation = pos.direction_to(direction * 2000000).angle()
	bullet.team = team
	bullet.damage = damage
	bullet.speed = speed
	
	add_child(bullet)
	await get_tree().create_timer(0.000001).timeout
	if bullet != null:
		bullet.set_direction(direction)]
 
func _process(_delta):
	pass
