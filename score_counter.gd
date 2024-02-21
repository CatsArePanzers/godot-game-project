extends Node2D

class_name ScoreCounter

var path: 	  String = "user://hi-score.cfg"
var password: String = "kotkamql"

var curr_score = 0
var hi_score = 90000

func _ready():
	pass

func add_score(score: int):
	curr_score += score
	
	if curr_score > hi_score:
		hi_score = curr_score

func init_hi_score():
	pass

func save_hi_score():
	var config = ConfigFile.new()
	
	config.set_value("hi_score_section", "hi_score", hi_score)
	
	config.save_encrypted_pass(path, password)

func load_hi_score():
	var config = ConfigFile.new()
	
	if config.load_encrypted_pass(path, password) != OK:
		hi_score = 0
		return
	
	hi_score = config.get_value("hi_score_section", "hi_score")
	
	print(hi_score)
