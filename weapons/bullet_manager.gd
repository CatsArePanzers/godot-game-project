extends Node2D

func _ready():
	GlobalShooting.connect("bullet_fired", self.handle_bullet)

func handle_bullet(bullet, pos, direction, team):
	bullet.global_position = pos
	bullet.team = team
	add_child(bullet)
	await get_tree().create_timer(0.000001).timeout 
	if bullet:
		bullet.set_direction(direction)

func _process(_delta):
	pass
