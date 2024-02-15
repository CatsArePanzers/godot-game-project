extends State

class_name StateIdle

func _ready():
	state_name = CharacterState.IDLE
	
func enter():
	super()
	
func exit():
	pass
	
func update(_delta):	
	character.velocity = Vector2.ZERO
	
	if character.target != null:
		change_state.emit(CharacterState.ATTACK)
		return
