extends Node
class_name StateMachine

var curr_state: State
var states: Dictionary = {}
var character: Character

func _ready():
	for child in get_children():
		if child is State:
			states[child.state_name] = child
			child.change_state.connect(change_state)

func set_character(p_character: Character):
	if p_character == null:
		character = null
		return
	
	character = p_character
	change_state(p_character.state)

func _process(delta):
	if curr_state and character:
		curr_state.update(delta)
	
func _physics_process(delta):
	if curr_state and character:
		curr_state.update(delta)

func change_state(new_state_name):
	if curr_state == null:
		curr_state = states[CharacterState.IDLE]
		curr_state.enter(character)
	
	if curr_state.state_name == new_state_name:
		return

	curr_state.exit()
	curr_state = states[new_state_name]
	curr_state.enter(character)
