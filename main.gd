extends Node2D

const EnemyControllerScene = preload("res://entities/enemies/enemy_controller.tscn")
const AllyControllerScene  = preload("res://entities/allies/ally_controller.tscn")

var player_idx: int = 0

var allies := Array()
var ally_controllers := Dictionary()

var enemies := Array()
var enemy_controllers := Dictionary()

@onready var map: NavigationRegion2D = $NavigationRegion2D

@onready var spawner_manager: SpawnerManager = $SpawnerManager

@onready var score_counter:	ScoreCounter = $ScoreCounter

func spawn_ally(path_to_resource):
	var new_ally: Character = load(path_to_resource).instantiate()
	
	new_ally.global_position = Vector2(randi_range(-100, 100), randi_range(-100, 100))
	
	add_child(new_ally)
	
	var rand_rotation = randf() * PI * 2
	new_ally.weapon.rotation 		 = rand_rotation
	new_ally.detection_zone.rotation = rand_rotation + PI/2
	
	allies.append(new_ally)
	
	var new_ally_controller: StateMachine = AllyControllerScene.instantiate()
	add_child(new_ally_controller)
	
	new_ally_controller.set_character(new_ally)
	ally_controllers[new_ally] = new_ally_controller
	
	new_ally.died.connect(remove_dead_ally)

func _ready():
	spawner_manager.enemy_spawned.connect(on_enemy_spawn)
	
	spawn_ally("res://entities/allies/types/ally_basic.tscn")
	
	allies[0].get_camera().make_current()
	ally_controllers[allies[0]].change_state(CharacterState.PLAYER)
	
	spawn_ally("res://entities/allies/types/ally_assault.tscn")
	spawn_ally("res://entities/allies/types/ally_sniper.tscn")
	spawn_ally("res://entities/allies/types/ally_tank.tscn")

func _unhandled_key_input(event):
	if event.is_action_released("switch_player"):
		switch_player()

func _physics_process(_delta):
	if enemies.is_empty():
		_on_spawner_timeout()
		$WaveTimer.start()

func _process(_delta):
	pass

func _on_spawner_timeout():
	spawner_manager.activate_spawners()

func switch_player():
	if allies.size() <= 1:
		return
	
	player_idx += 1
	player_idx %= allies.size()
	
	if allies[player_idx] == null:
		allies.pop_at(player_idx)
		player_idx %= allies.size()
	
	ally_controllers[allies[player_idx - 1]].change_state(CharacterState.IDLE)
	ally_controllers[allies[player_idx]].change_state(CharacterState.PLAYER)
	
	switch_camera(allies[player_idx - 1].get_camera(), allies[player_idx].get_camera())	

func switch_camera(curr_camera: Camera2D, new_camera: Camera2D):	
	var tween: Tween = get_tree().create_tween()

	new_camera.make_current()

	new_camera.reset_smoothing()
	new_camera.global_position = new_camera.get_target_position()
	new_camera.align()
	
	new_camera.offset = curr_camera.global_position - new_camera.global_position	
	
	tween.tween_property(new_camera, "offset", Vector2.ZERO, 0.3)
	await tween.finished

func remove_dead_ally(dead_ally: Ally):
	if ally_controllers.get(dead_ally) == null:
		return
	
	ally_controllers[dead_ally].queue_free()
	ally_controllers.erase(dead_ally)
	allies.pop_at(allies.find(dead_ally))
	
	if(dead_ally.state == CharacterState.PLAYER):
		switch_player()

func remove_dead_enemy(dead_enemy: Enemy):
	if enemy_controllers.get(dead_enemy) == null:
		return
	
	score_counter.add_score(dead_enemy.score_worth)
	
	enemy_controllers[dead_enemy].queue_free()
	enemy_controllers.erase(dead_enemy)
	enemies.pop_at(enemies.find(dead_enemy))

func on_enemy_spawn(new_enemy: Enemy):
	add_child(new_enemy)
	
	var rand_rotation = randf() * PI * 2
	new_enemy.weapon.rotation 		  = rand_rotation
	new_enemy.detection_zone.rotation = rand_rotation + PI/2
	
	enemies.append(new_enemy)
	
	var new_enemy_controller: StateMachine = EnemyControllerScene.instantiate()
	add_child(new_enemy_controller)
	
	new_enemy_controller.set_character(new_enemy)
	enemy_controllers[new_enemy] = new_enemy_controller
	
	new_enemy.died.connect(remove_dead_enemy)
	
	new_enemy.follow_path.emit()
