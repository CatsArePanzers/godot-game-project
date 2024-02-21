extends Node2D

class_name WeaponComponent

signal changed_weapon(weapon)

var team

var curr_weapon: Weapon
var weapon_idx = 0

var weapons := Array()

func switch_weapon(idx):
	curr_weapon.visible = false
	
	curr_weapon = weapons[idx]
	
	curr_weapon.visible = true
	
	changed_weapon.emit(curr_weapon)
	
	return curr_weapon

func change_weapon(weapon_change = 1):
	weapon_idx += weapon_change
	weapon_idx %= weapons.size()
	
	curr_weapon.visible = false
	
	curr_weapon = weapons[weapon_idx]
	
	curr_weapon.visible = true
	
	changed_weapon.emit(curr_weapon)
	
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

