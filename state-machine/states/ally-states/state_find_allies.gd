extends State

class_name StateFindAllies

func _ready():
	state_name = CharacterState.FIND_ALLIES
	
func enter():
	super()
	
func exit():
	pass
	
func update(_delta):
	if character == null:
		return
	
	if character.last_seen_ally == null:
		change_state.emit(CharacterState.WANDER)
		#print("vat")
		return
	
	var direction_to_ally = character.global_position.direction_to(character.last_seen_ally.global_position)
	
	character.set_nav_agent_target_pos(character.last_seen_ally.global_position - direction_to_ally * 100)
	
	character.velocity = character.get_move_direction()
	
	character.velocity *= character.speed
	
	if (
			character.nav_agent.is_target_reached()
			or character.allies_in_range >= 2
		):
		change_state.emit(CharacterState.WANDER)
	
	character.move_and_slide()

