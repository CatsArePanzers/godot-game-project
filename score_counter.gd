extends Node2D

class_name ScoreCounter

var curr_score = 0
var hi_score = 0

func _ready():
	pass

func add_score(score: int):
	curr_score += score
	
	if curr_score > hi_score:
		hi_score = curr_score
		
	print(curr_score)

func init_hi_score():
	pass
