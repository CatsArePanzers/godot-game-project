extends State

class_name StateHit

func _ready():
	state_name = CharacterState.HIT
	
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
				character.global_position.distance_to(character.target_pos) >= 20
				and abs(character.weapon.global_rotation - angle) <= PI/36
		):
			character.velocity = character.get_move_direction() * character.speed
			character.move_and_slide()
	elif character.global_position.distance_to(character.target_pos) <= 20:
		change_state.emit(CharacterState.IDLE)
