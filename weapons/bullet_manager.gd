extends Node2D

func _ready():
	pass
	
func handle_bullet(bullet, pos, direction):
	add_child(bullet)
	bullet.global_position = pos
	await get_tree().create_timer(0.001).timeout 
	bullet.set_direction(direction)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
