extends Node2D


# Called when the node enters the scene tree for the first time
@onready var bullet_manager = $bullet_manager

func spawn_enemy():
	var new_enemy = preload("res://entities/enemies/enemy.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_enemy.global_position = %PathFollow2D.global_position
	add_child(new_enemy)

func _ready():
	#GlobalShooting.connect("bullet_fired", bullet_manager.handle_bullet)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_spawner_timeout():
	spawn_enemy()
