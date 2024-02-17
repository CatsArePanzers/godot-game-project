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
	var distance_to_target: float = -1
	
	if character.target:
		distance_to_target = character.global_position.distance_to(character.target.global_position)
	
	if distance_to_target > character.weapon.desired_range or distance_to_target == -1:
		character.velocity = character.get_move_direction() * character.speed
	else:
		character.velocity = character.global_position.direction_to(character.target.global_position)
		if distance_to_target > character.weapon.desired_range:
			character.velocity *= character.speed
		elif distance_to_target < character.weapon.desired_range / 4:
			character.velocity *= -character.speed
		else:
			character.velocity = Vector2.ZERO
	
	character.move_and_slide()
