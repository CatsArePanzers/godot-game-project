extends Node

class_name State

signal change_state(new_state_name)

var state_name: int
var character: Character

func _ready():
	pass

func set_character(p_character: Character):
	character = p_character
	character.commenced_attack.connect(change_state_attack)
	character.got_hit.connect(change_state_hit)
	
	if character.has_signal("find_allies"):
		character.find_allies.connect(change_state_find_allies)
	
	if character.has_signal("follow_path"):
		character.follow_path.connect(change_state_follow_path)
	

func enter():
	if character == null:
		return
	
	character.state = state_name

func exit():
	pass

func update(_delta):
	pass

func change_state_attack():
	if character.state != CharacterState.PLAYER:
		change_state.emit(CharacterState.ATTACK)

func change_state_hit():
	if character.state != CharacterState.PLAYER:
		change_state.emit(CharacterState.MOVE_TO)

func change_state_find_allies():
	if character.state != CharacterState.PLAYER:
		change_state.emit(CharacterState.FIND_ALLIES)

func change_state_follow_path():
	change_state.emit(CharacterState.FOLLOW_PATH)

