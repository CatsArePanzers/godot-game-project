extends State

class_name StateAttack

func _ready():
	state_name = CharacterState.ATTACK
	
func enter(p_character):
	super(p_character)
	
func exit():
	pass
	
func update(delta):
	if character.target == null or character.weapon == null:
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

func move_character(delta):
	if character.target:
		character.velocity 		  = character.global_position.direction_to(character.target.global_position).normalized()
		character.target_distance = character.global_position.distance_to(character.target.global_position)
	else: 
		character.velocity = Vector2.ZERO
		character.arget_distance = -1
	
	if character.target_distance > 300:
		character.velocity *= character.speed
	elif character.target_distance < 150:
		character.velocity *= -character.speed
	else:
		character.velocity = Vector2.ZERO
		
	character.move_and_slide()
