extends State

class_name StateFollowPath

func _ready():
	state_name = CharacterState.FOLLOW_PATH

func enter():
	super()
	
func exit():
	pass
	
func update(delta):
	if character.path_to_follow == null:
		change_state.emit(CharacterState.IDLE)
		return
	
	if !has_reached_path_start():
		return
	
	character.path_to_follow.progress += character.speed * delta + character.nav_agent.target_desired_distance
	character.set_nav_agent_target_pos(character.path_to_follow.global_position)

	if (
			character.path_to_follow.progress_ratio >= 1
		):
		change_state.emit(CharacterState.IDLE)

func has_reached_path_start() -> bool:
	if character.nav_agent.is_target_reached():
		return true
	
	character.velocity = character.get_move_direction()
	character.velocity *= character.speed
	
	character.set_nav_agent_target_pos(character.path_to_follow.global_position)
	
	character.move_and_slide()
	
	return false
