extends Node2D

func spawn_enemy():
	var new_enemy = preload("res://entities/enemies/enemy.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_enemy.global_position = %PathFollow2D.global_position
	add_child(new_enemy)
	var rand_rotation = randf() * PI * 2
	new_enemy.gun.rotation 				 = rand_rotation
	new_enemy.ai.detection_zone.rotation = rand_rotation + PI/2

func _ready():
	pass

func _process(_delta):
	pass

func _on_spawner_timeout():
	spawn_enemy()
