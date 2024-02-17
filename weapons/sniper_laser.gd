extends RayCast2D

@export var laser_collision_mask: int = ~0
@onready var laser_body = $LaserBody

func _ready():
	collision_mask = laser_collision_mask

func _process(_delta):
	pass

func _physics_process(_delta):
	if get_collider():
		laser_body.size = Vector2(global_position.distance_to(get_collision_point()), 1)
