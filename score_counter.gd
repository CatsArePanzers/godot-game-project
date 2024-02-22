extends Node2D

class_name ScoreCounter

signal score_changed(points)
signal new_hiscore_made(points)

var path: 	  String = "user://hi-score.cfg"
var password: String = "kotkamql"

var hi_score_name: String

var hi_score = 0
var curr_score: int:
	get:
		return curr_score
	set(p_curr_score):
		curr_score = p_curr_score
		
		score_changed.emit(curr_score)
	
		if curr_score > hi_score:
			hi_score = curr_score
			new_hiscore_made.emit(curr_score)

func _ready():
	load_hi_score()

func add_score(score: int):
	curr_score += score
	
	score_changed.emit(curr_score)
	
	if curr_score > hi_score:
		hi_score = curr_score
		new_hiscore_made.emit(curr_score)

func init_hi_score():
	pass

func save_hi_score():
	var config = ConfigFile.new()
	
	config.set_value("hi_score_section", "hi_score", hi_score)
	
	if hi_score_name == null or hi_score_name.is_empty():
		hi_score_name = "anonymous"
	
	config.set_value("hi_score_name", "name", hi_score_name)
	
	config.save_encrypted_pass(path, password)

func load_hi_score():
	var config = ConfigFile.new()
	
	if config.load_encrypted_pass(path, password) != OK:
		hi_score = 0
		hi_score_name = "anonymous"
		return
	
	hi_score = config.get_value("hi_score_section", "hi_score")
	hi_score_name = config.get_value("hi_score_name", "name")
