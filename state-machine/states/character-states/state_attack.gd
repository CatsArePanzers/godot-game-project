extends State

class_name StateAttack

func _ready():
	state_name = CharacterState.ATTACK

func enter():
	super()

func exit():
	pass
	
func update(delta):
	if character.target == null or character.weapon == null:
		if character.target != null:
			return
		
		character.turn_to(character.get_next_pos(), character.rotation_speed * delta)
		
		if character.nav_agent.is_target_reached():
			change_state.emit(CharacterState.MOVE_TO)
		
		move_character(delta)
		return
	
	character.turn_to(character.target.global_position, character.rotation_speed * delta)

	var angle = character.weapon.global_position.direction_to(character.target.global_position).angle()
	if (
			character.shoot_cooldown.is_stopped()
			and fmod(abs(character.weapon.global_rotation - angle), PI * 1.99) <= PI/18
	):
		character.weapon.shoot()
		character.shoot_cooldown.start()
	
	move_character(delta)

func move_character(_delta):
	if !character.target or !character.nav_agent.is_target_reached():
		character.velocity = character.get_move_direction() * character.speed
		character.move_and_slide()
		return
	
	var distance_to_target = character.global_position.distance_to(character.target.global_position)
	var direction = character.global_position.direction_to(character.target.global_position)
	var move_distance
	
	if distance_to_target > character.weapon.desired_range * 5/6:
		move_distance = direction * character.weapon.desired_range / 2
	elif distance_to_target < character.weapon.desired_range / 3:
		move_distance = -(direction * character.weapon.desired_range / 3)
	else:
		move_distance = Vector2.ZERO
		character.velocity = Vector2.ZERO
	
	character.set_nav_agent_target_pos(character.global_position + move_distance)
	character.move_and_slide()
