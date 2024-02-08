extends Node2D

var allies = Array()
var camera_idx: int = 0

func spawn_enemy():
	var new_enemy = preload("res://entities/enemies/enemy.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_enemy.global_position = %PathFollow2D.global_position
	add_child(new_enemy)
	var rand_rotation = randf() * PI * 2
	new_enemy.gun.rotation 				 = rand_rotation
	new_enemy.ai.detection_zone.rotation = rand_rotation + PI/2

func spawn_ally():
	var new_ally = preload("res://entities/allies/ally.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_ally.global_position = %PathFollow2D.global_position
	add_child(new_ally)
	var rand_rotation = randf() * PI * 2
	new_ally.gun.rotation 				= rand_rotation
	new_ally.ai.detection_zone.rotation = rand_rotation + PI/2
	allies.append(new_ally)
	new_ally.connect("died", remove_dead_ally)

func _ready():
	allies.push_front($Player)
	spawn_enemy()
	spawn_ally()
	spawn_enemy()
	spawn_ally()
	spawn_enemy()
	spawn_ally()
	
	allies[0].get_camera().make_current()

func _unhandled_key_input(event):
	if event.is_action_released("switch_player"):
		camera_idx += 1
		camera_idx %= allies.size()
		
		if allies[camera_idx] == null:
			allies.pop_at(camera_idx)
			print("meow ", allies.size(), " ", camera_idx)
			camera_idx %= allies.size()
			
		switch_camera(allies[camera_idx - 1].get_camera(), allies[camera_idx].get_camera())	

func _process(_delta):
	pass

func _on_spawner_timeout():
	spawn_enemy()
	spawn_ally()
	pass
	
func switch_camera(curr_camera: Camera2D, new_camera: Camera2D):	
	var tween: Tween = get_tree().create_tween()
	
	#var path_to_camera: Vector2 = curr_camera.global_position.direction_to(new_camera.global_position) * curr_camera.global_position.distance_to(curr_camera.global_position)
	
	tween.tween_property(curr_camera, "offset", new_camera.global_position - curr_camera.global_position, 0.2)
	
	await tween.finished
	
	curr_camera.offset = Vector2.ZERO
	new_camera.make_current()

func remove_dead_ally(dead_ally):
	allies.pop_at(allies.find(dead_ally))
	
