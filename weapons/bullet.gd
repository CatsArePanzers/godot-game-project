extends Area2D

@export var speed: int = 900

var team: int

var direction := Vector2.ZERO

func _physics_process(delta):
	if direction != Vector2.ZERO:
		var velocity = direction * speed * delta
		global_position += velocity

func set_direction(new_direction):
	self.direction = new_direction

func _on_body_entered(body):
	if body.has_method("take_damage") and body.get_team() != team:
		body.take_damage(20)
	queue_free()
	if body.has_method("set_state") and body.get_state() != 2:
		body.set_state(1)
		body.ai.hit_from = global_position - (direction * speed)
	
"""
func _on_body_exited(_body):
	queue_free()
"""
