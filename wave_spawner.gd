extends Area2D

class_name Spawner

signal enemy_spawned(new_enemy: Enemy)

const enemy_basic 	= preload("res://entities/enemies/types/enemy_basic.tscn")
const enemy_assault = preload("res://entities/enemies/types/enemy_assault.tscn")
const enemy_sniper 	= preload("res://entities/enemies/types/enemy_sniper.tscn")
const enemy_tank	= preload("res://entities/enemies/types/enemy_tank.tscn")

var spawn_area: CollisionShape2D
var path	  : Path2D

func _ready():
	for child in get_children():
		if child is Path2D:
			path = child

		if child is CollisionShape2D:
			spawn_area = child
	
	if spawn_area == null:
		print("Spawner requires CollisionShape2D node as child")
		queue_free()

func spawn_enemy(enemy_type):
	spawn_area
	
	
	#var new_enemy: Enemy = 
	
	
	
	#enemy_spawned.emit(new_enemy)
	pass

func _process(delta):
	pass
