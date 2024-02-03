extends Area2D

@export var speed: int = 900

var direction := Vector2.ZERO

func _physics_process(delta):
	if direction != Vector2.ZERO:
		var velocity = direction * speed * delta
		global_position += velocity

func set_direction(new_direction):
	self.direction = new_direction

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(20)
	queue_free()

"""
func _on_body_exited(_body):
	queue_free()
"""
