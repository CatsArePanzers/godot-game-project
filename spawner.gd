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
	var new_enemy: Enemy = enemy_basic.instantiate()
	
	new_enemy.global_position = create_random_position()
	
	new_enemy.path_to_follow = path.get_child(0)
	
	enemy_spawned.emit(new_enemy)

func create_random_position() -> Vector2:
	var spawn_position_rect: Rect2 = spawn_area.shape.get_rect()
	
	var spawn_area_start: Vector2 = spawn_area.global_position + spawn_position_rect.position
	
	print(spawn_area_start)
	
	var rand_deviation := Vector2(randf() * spawn_position_rect.size.x,
								  randf() * spawn_position_rect.size.y)
	
	return spawn_area_start + rand_deviation


