extends Node

class_name State

signal change_state(new_state_name)

@export var state_name: int
@export var character: Character

func _ready():
	pass

func enter(p_character: Character):
	character = p_character
	character.state = state_name

func exit():
	pass

func update(_delta):
	pass
