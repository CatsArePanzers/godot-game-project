extends Node

class_name State

signal change_state(new_state_name)

@export var state_name: int
@export var character: Character

func _ready():
	pass

func set_character(p_character: Character):
	character = p_character
	character.commenced_attack.connect(change_state_attack)
	character.got_hit.connect(change_state_hit)

func enter():
	character.state = state_name

func exit():
	pass

func update(_delta):
	pass

func change_state_attack():
	change_state.emit(CharacterState.ATTACK)

func change_state_hit():
	change_state.emit(CharacterState.HIT)

