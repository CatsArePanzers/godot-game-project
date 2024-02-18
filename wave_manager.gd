extends Node2D

class_name SpawnerManager

var spawners := Array()

func _ready():
	spawners = get_children()

func _process(delta):
	pass
