extends Node2D

class_name Main

const EnemyControllerScene = preload("res://entities/enemies/enemy_controller.tscn")
const AllyControllerScene  = preload("res://entities/allies/ally_controller.tscn")

const PauseMenuScene = preload("res://ui/pause_game_screen.tscn")
const GameOverScene  = preload("res://ui/game_over_screen.tscn")
const HiScoreScene = preload("res://ui/hi-score-screen.tscn")

var player_idx: int = 0

var wave_wait_timer: int = 30

var allies: Array[Ally] = []
var ally_controllers := Dictionary()

var enemies :Array[Enemy] = []
var enemy_controllers := Dictionary()

@onready var map: NavigationRegion2D = $NavigationRegion2D

@onready var spawner_manager: SpawnerManager = $SpawnerManager

@onready var score_counter:	ScoreCounter = $ScoreCounter

@onready var gui: MainGUI = $MainScreenGUI

func _load(config: ConfigFile, sections):
	for controller in ally_controllers:
		controller.queue_free()
	ally_controllers.clear()

	for controller in enemy_controllers:
		controller.queue_free()
	enemy_controllers.clear()
	
	for ally in allies:
		ally.queue_free()
	allies.clear()
	
	for enemy in enemies:
		enemy.queue_free()
	enemies.clear()
	
	for element in get_tree().get_nodes_in_group("can_save"):
		element.queue_free()
	
	print(allies)
	print(ally_controllers)
	
	$WaveTimer.start(config.get_value("main_vars", "wave_time"))
	score_counter.curr_score = config.get_value("main_vars", "curr_score")
	
	gui.init(score_counter, null)
	
	sections.remove_at(sections.find("main_vars"))
	
	_on_one_second_timeout()
	
	for section in sections:
		var entity = load(config.get_value(section, "scene_path")).instantiate()
		
		get_node(config.get_value(section, "parent_node_path")).add_child(entity)
		
		if entity.has_signal("ally_loaded"):
			allies.append(entity)
			entity.ally_loaded.connect(add_ally_state_machine)
		elif entity.has_signal("enemy_loaded"):
			enemies.append(entity)
			entity.enemy_loaded.connect(add_enemy_state_machine)
			
		entity._load(config, section)
	
	return

func _save(save_file: ConfigFile):
	print(get_tree().get_nodes_in_group("can_save"))
	
	for element in get_tree().get_nodes_in_group("can_save"):
		element._save(save_file)
	
	save_file.set_value("main_vars", "wave_time", $WaveTimer.time_left)
	save_file.set_value("main_vars", "curr_score", score_counter.curr_score)
	
	return

func _init():
	pass

func _ready():
	SaveAgent.main_scene_file_path = scene_file_path
	SaveAgent.main_scene_path = get_path()
	SaveAgent.main_scene = self
	
	spawner_manager.enemy_spawned.connect(on_enemy_spawn)

	spawn_ally("res://entities/allies/types/ally_basic.tscn")
	spawn_ally("res://entities/allies/types/ally_assault.tscn")
	spawn_ally("res://entities/allies/types/ally_sniper.tscn")
	spawn_ally("res://entities/allies/types/ally_tank.tscn")

	allies[0].get_camera().make_current()
	ally_controllers[allies[0]].change_state(CharacterState.PLAYER)
	
	gui.init(score_counter, allies[0])
	_on_one_second_timeout()

func spawn_ally(path_to_resource):
	var new_ally: Character = load(path_to_resource).instantiate()
	
	new_ally.global_position = Vector2(randi_range(-100, 100), randi_range(-100, 100))
	
	add_child(new_ally)
	
	var rand_rotation = randf() * PI * 2
	new_ally.weapon.rotation 		 = rand_rotation
	new_ally.detection_zone.rotation = rand_rotation + PI/2
	
	allies.append(new_ally)
	
	add_ally_state_machine(new_ally)

func add_ally_state_machine(new_ally: Ally):
	var new_ally_controller: StateMachine = AllyControllerScene.instantiate()
	add_child(new_ally_controller)
	
	new_ally_controller.set_character(new_ally)
	ally_controllers[new_ally] = new_ally_controller
	
	new_ally.died.connect(remove_dead_ally)
	
	if new_ally.state == CharacterState.PLAYER:
		new_ally.get_camera().make_current()
		ally_controllers[new_ally].change_state(CharacterState.PLAYER)
		player_idx = allies.find(new_ally)
		gui.set_character(new_ally)

func _unhandled_key_input(event):
	if event.is_action_released("switch_player"):
		switch_player()
	
	if event.is_action_pressed("pause") and get_tree().paused == false:
		add_child(PauseMenuScene.instantiate())

func _physics_process(_delta):
	if enemies.is_empty():
		_on_spawner_timeout()
		$WaveTimer.start()
	
	if allies.size() == 0:
		end_game()

func _process(_delta):
	pass

func _on_spawner_timeout():
	spawner_manager.activate_spawners()
	$WaveTimer.set_wait_time(wave_wait_timer)

func switch_player():
	if allies.size() < 1:
		return
	
	player_idx += 1
	player_idx %= allies.size()
	
	if allies[player_idx] == null:
		allies.pop_at(player_idx)
		player_idx %= allies.size()
	
	ally_controllers[allies[player_idx - 1]].change_state(CharacterState.WANDER)
	ally_controllers[allies[player_idx]].change_state(CharacterState.PLAYER)
	
	gui.set_character(allies[player_idx])
	
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
	
	dead_ally.queue_free()

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
	
	add_enemy_state_machine(new_enemy)

func add_enemy_state_machine(new_enemy):
	var new_enemy_controller: StateMachine = EnemyControllerScene.instantiate()
	add_child(new_enemy_controller)
	
	new_enemy_controller.set_character(new_enemy)
	enemy_controllers[new_enemy] = new_enemy_controller
	
	new_enemy.died.connect(remove_dead_enemy)
	
	new_enemy.follow_path.emit()

func end_game():
	if score_counter.curr_score == score_counter.hi_score:
		var hi_score_screen = HiScoreScene.instantiate()
		hi_score_screen.set_score_counter(score_counter)
		add_child(hi_score_screen)
	
	add_child(GameOverScene.instantiate())

func _on_one_second_timeout():
	gui.manage_wave_timer($WaveTimer.time_left)
