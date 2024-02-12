extends Character

@onready var camera = $Camera

func _physics_process(delta):
	super(delta)

func get_camera():
	return camera
