extends Node2D

func _ready():
	GlobalShooting.connect("bullet_fired", self.handle_bullet)

func handle_bullet(bullet, pos, direction, team):
	add_child(bullet)
	bullet.global_position = pos
	bullet.team = team
	await get_tree().create_timer(0.001).timeout 
	if bullet:
		bullet.set_direction(direction)

func _process(_delta):
	pass
