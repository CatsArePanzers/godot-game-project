extends Character

class_name Enemy

var path_to_follow: PathFollow2D

func _ready():
	super()

func _physics_process(delta):
	super(delta)
