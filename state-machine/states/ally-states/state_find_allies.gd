extends State

class_name StateFindAllies

func _ready():
	state_name = CharacterState.FIND_ALLIES
	
func enter():
	super()
	
func exit():
	pass
	
func update(_delta):	
	character.set_nav_agent_target_pos(character.last_seen_ally.global_position)
	
	character.velocity = character.get_move_direction()
	
	character.velocity *= character.speed
	
	if (
			character.nav_agent.is_target_reached()
			or character.allies_in_range >= 1
		):
		change_state.emit(CharacterState.IDLE)
	
	character.move_and_slide()

