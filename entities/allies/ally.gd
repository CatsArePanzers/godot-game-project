extends Character

class_name Ally

@onready var camera = $Camera

func _ready():
	super()

func _physics_process(delta):
	super(delta)

func get_camera():
	return camera
