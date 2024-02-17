extends State

class_name StateMoveTo

var last_pos := Vector2.ZERO

func _ready():
	state_name = CharacterState.MOVE_TO
	
func enter():
	super()

func exit():
	pass
	
func update(delta):
	if character.target != null:
		change_state.emit(CharacterState.ATTACK)
		return
	
	character.turn_to(character.target_pos, character.rotation_speed * delta * 5)

	var angle = character.global_position.direction_to(character.target_pos).angle()
	
	if (
				!character.nav_agent.is_target_reached()
				and character.nav_agent.is_target_reachable()
				#asand fmod(abs(character.weapon.global_rotation - angle), TAU - 0.1) < PI/18
		):
			
			character.velocity = character.get_move_direction() * character.speed
			character.move_and_slide()
			
			print(character.nav_agent.distance_to_target())
			print(character.nav_agent.is_target_reachable())
			print(character.global_position.distance_to(character.nav_agent.get_final_position()))
			
	elif character.nav_agent.is_target_reached():
		var ray = character.create_ray(character.global_position, character.velocity * 2000)
		if character.global_position.distance_to(ray["position"]) >= 60:
			character.velocity = Vector2(character.velocity.x + randf_range(-20, 20), 
										 character.velocity.y + randf_range(-20, 20))
			character.velocity = character.velocity.normalized() * character.speed
			character.set_move_target(character.velocity * 2000)
		else:
			character.velocity = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * character.speed
			character.set_move_target(character.velocity * 2000)
	else:
		print("cat")
		print(character.nav_agent.distance_to_target())
		print(character.nav_agent.is_target_reachable())
		print(character.global_position.distance_to(character.nav_agent.get_final_position()))
