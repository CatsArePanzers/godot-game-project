extends State

class_name StateFollowPath

func _ready():
	state_name = CharacterState.FOLLOW_PATH

func enter():
	super()
	
func exit():
	pass
	
func update(delta):
	#print("cat")
	
	character.velocity = character.get_move_direction()
	character.velocity *= character.speed
	character.path_to_follow.progress += character.speed * delta
	
	character.set_nav_agent_target_pos(character.path_to_follow.global_position)

	if (
			character.nav_agent.is_target_reached()
		):
		change_state.emit(CharacterState.IDLE)
	
	character.move_and_slide()

