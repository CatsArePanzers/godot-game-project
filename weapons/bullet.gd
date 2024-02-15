extends Area2D

class_name Bullet

var speed: int = 1000
var direction := Vector2.ZERO
var velocity  := Vector2.ZERO
var damage: int
var team: int

func _physics_process(delta):
	if direction != Vector2.ZERO:
		velocity = direction * speed * delta
		global_position += velocity

func set_direction(new_direction):
	self.direction = new_direction

func _on_body_entered(body):
	if body.has_method("get_team") == false:
		queue_free()
		return
	
	if body.get_team() == team:
		queue_free()
		return
	
	if body.has_method("take_damage"):
		body.take_damage(damage)
	
	if body.has_method("get_state"):
		#print(body.global_position.direction_to(global_position - velocity * 2000).angle())
		#print((body.global_position.distance_to(body.end_of_fov.global_position) * (body.global_position - direction * 2000000).normalized()).angle())
		#print((body.global_position - direction * 2000000000).angle())
		body.get_hit_from(body.global_position - direction * 2000000000)
	
	queue_free()
