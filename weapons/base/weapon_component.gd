extends Node2D

class_name WeaponComponent

signal change_weapon

var team

var curr_weapon: Weapon

var weapons := Array()

func set_team(p_team):
	team = p_team
	
	for weapon: Weapon in weapons:
		weapon.set_team(team)

func get_current_weapon() -> Weapon:
	return curr_weapon

func _ready():
	weapons = get_children()
		
	curr_weapon = weapons[0]

func _process(delta):
	pass

