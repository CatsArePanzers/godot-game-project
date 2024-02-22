extends CanvasLayer

class_name MainGUI

@onready var hi_score_points: Label = $MarginContainer/Rows/ScoreRow/HighScore/Points
@onready var hi_score_user_name: Label = $MarginContainer/Rows/ScoreRow/HighScore/Name

@onready var score_points: Label = $MarginContainer/Rows/ScoreRow/Score/ScorePoints

@onready var currect_ammo: Label = $MarginContainer/Rows/AmmoRow/CurrAmmo
@onready var max_ammo: Label = $MarginContainer/Rows/AmmoRow/MaxAmmo

@onready var next_wave_time: Label = $MarginContainer/Rows/ScoreRow/Wave/Timer

var player: Ally
var score_counter: ScoreCounter

func init(p_score_counte: ScoreCounter, p_player: Ally):
	if score_counter != p_score_counte:
		score_counter = p_score_counte
		set_hi_score()
		score_counter.new_hiscore_made.connect(new_hi_score)
		score_counter.score_changed.connect(manage_score)
	
	manage_score(score_counter.curr_score)
	
	set_character(p_player)

func set_hi_score():
	hi_score_points.text = str(score_counter.hi_score) 
	manage_hi_score_name()

func new_hi_score(_points):
	hi_score_points.text = "New Hi-Score" 
	hi_score_user_name.visible = false

func manage_hi_score_name():
	if hi_score_points.text != "0":
		hi_score_user_name.text = "by " + score_counter.hi_score_name
	else:
		hi_score_user_name.text = ""

func manage_score(_points):
	score_points.text = str(_points)

func set_max_ammo():
	max_ammo.text = str(player.weapon.ammo_amount)

func manage_ammo():
	if player.weapon.current_ammo == 0:
		reloading()
	else:
		currect_ammo.text = str(player.weapon.current_ammo)

func reloading():
	currect_ammo.text = "Reloading!"

func manage_wave_timer(time_left: int):
	next_wave_time.text = str(time_left)



func _ready():
	pass

func set_character(new_player: Ally):
	if new_player == null:
		return
	
	if player == new_player:
		return
	
	if player != null:
		player.weapon.fired.disconnect(manage_ammo)
		player.weapon.reloading.disconnect(reloading)
		player.weapon.reloaded.disconnect(manage_ammo)
		player.changed_weapon.disconnect(on_weapon_change)
	
	player = new_player
	set_max_ammo()
	manage_ammo()
	
	player.weapon.fired.connect(manage_ammo)
	player.weapon.reloading.connect(reloading)
	player.weapon.reloaded.connect(manage_ammo)
	player.changed_weapon.connect(on_weapon_change)

func on_weapon_change(weapon):
	if !weapon or !player:
		return
	
	set_max_ammo()
	manage_ammo()
	
	if !player.weapon.fired.is_connected(manage_ammo):
		player.weapon.fired.connect(manage_ammo)
	
	if !player.weapon.reloading.is_connected(reloading):
		player.weapon.reloading.connect(reloading)
	
	if !player.changed_weapon.is_connected(on_weapon_change):
		player.changed_weapon.connect(on_weapon_change)
	
	if !player.weapon.reloaded.is_connected(manage_ammo):
		player.weapon.reloaded.connect(manage_ammo)
