extends Character

class_name Enemy

signal follow_path

var path_to_follow: PathFollow2D

func _ready():
	super()

func _physics_process(delta):
	super(delta)
