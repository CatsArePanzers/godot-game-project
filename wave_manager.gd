extends Node2D

class_name SpawnerManager

signal enemy_spawned(new_ebnemy: Enemy)

var spawners := Array()

func _ready():
	spawners = get_children()
	
	for spawner: Spawner in spawners:
		spawner.enemy_spawned.connect(on_enemy_spawn)

func _process(delta):
	pass

func on_enemy_spawn(new_enemy: Enemy):
	enemy_spawned.emit(new_enemy)
