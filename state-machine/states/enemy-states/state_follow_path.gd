extends State

class_name StateFollowPath

var path_follow :PathFollow2D

func _ready():
	state_name = CharacterState.FOLLOW_PATH

func enter():
	super()
	
func exit():
	pass
	
func update(_delta):
	character.set_nav_agent_target_pos(Vector2.ZERO)
	
	character.velocity = character.get_move_direction()
	
	character.velocity *= character.speed
	
	if (
			character.nav_agent.is_target_reached()
		):
		change_state.emit(CharacterState.IDLE)
	
	character.move_and_slide()

