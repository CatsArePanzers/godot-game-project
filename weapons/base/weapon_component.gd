extends Node2D

class_name WeaponComponent

signal change_weapon(weapon)

var team

var curr_weapon: Weapon

var weapons := Array()

func switch_weapon(weapon_change = 1):
	var weapon_idx = weapons.find(curr_weapon)
	weapon_idx += weapon_change
	weapon_idx %= weapons.size()
	
	curr_weapon.visible = false
	
	curr_weapon = weapons[weapon_idx]
	
	curr_weapon.visible = true
	
	change_weapon.emit(curr_weapon)
	
	return curr_weapon

func set_team(p_team):
	team = p_team
	
	for weapon: Weapon in weapons:
		weapon.set_team(team)
		
		if weapon.has_node("LaserDetection"):
			weapon.get_node("LaserDetection").collision_mask = get_parent().collision_mask ^ get_parent().collision_layer

func get_current_weapon() -> Weapon:
	return curr_weapon

func _ready():
	weapons = get_children()
		
	curr_weapon = weapons[0]

func _process(_delta):
	pass

