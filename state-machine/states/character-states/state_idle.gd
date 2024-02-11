extends State

class_name StateIdle

func _ready():
	state_name = CharacterState.IDLE
	
func enter(p_character):
	super(p_character)
	
func exit():
	pass
	
func update(_delta):
	character.velocity = Vector2.ZERO
