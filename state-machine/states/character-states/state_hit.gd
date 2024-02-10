extends State

class_name StateHit

func _ready():
	state_name = CharacterState.HIT
	
func enter(p_character):
	super(p_character)
	
func exit():
	pass
	
func update(delta):
	if character.target != null:
		change_state.emit(CharacterState.ATTACK)
		return
		
	#var hit_direction = character.global_position.direction_to(character.move_pos)
		
	character.turn_to(character.move_pos, character.rotation_speed * delta * 5)
			
	var angle = character.weapon.global_position.direction_to(character.move_pos).angle()
	
	if (
			character.global_position.distance_to(character.move_pos) >= 20
			and abs(character.weapon.global_rotation - angle) <= PI/360
		):
		character.velocity = character.global_position.direction_to(character.move_pos).normalized() * character.speed
		character.move_and_slide()
	elif character.global_position.distance_to(character.move_pos) <= 20:
		change_state.emit(CharacterState.IDLE)
