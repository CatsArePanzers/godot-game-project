extends Area2D

class_name Spawner

signal enemy_spawned(new_enemy: Enemy)

var spawn_area: CollisionShape2D
var path	  : Path2D

@export var spawn_number: int
@export var enemy_types: Array[PackedScene] = []

func _ready():
	for child in get_children():
		if child is Path2D:
			path = child

		if child is CollisionShape2D:
			spawn_area = child
	
	if spawn_area == null:
		print("Spawner requires CollisionShape2D node as child")
		queue_free()

func spawn_enemy():
	var enemy_type_idx = randi_range(1, enemy_types.size()) - 1
	
	var new_enemy: Enemy = enemy_types[enemy_type_idx].instantiate()
	
	new_enemy.global_position = create_random_position()
	
	if path != null:
		new_enemy.path = path
		new_enemy.path_to_follow = PathFollow2D.new()
		new_enemy.path.add_child(new_enemy.path_to_follow)
		new_enemy.path_to_follow.rotates = false
		new_enemy.path_to_follow.loop = false
	else:
		new_enemy.path_to_follow = PathFollow2D.new()
		new_enemy.path_to_follow.global_position = Vector2.ZERO
	
	enemy_spawned.emit(new_enemy)

func create_random_position() -> Vector2:
	var spawn_position_rect: Rect2 = spawn_area.shape.get_rect()
	
	var spawn_area_start: Vector2 = spawn_area.global_position + spawn_position_rect.position
	
	var rand_deviation := Vector2(randf() * spawn_position_rect.size.x,
								  randf() * spawn_position_rect.size.y)
	
	return spawn_area_start + rand_deviation


