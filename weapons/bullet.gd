extends Area2D

@export var speed: int = 1000

var team: int

var direction := Vector2.ZERO
var velocity  := Vector2.ZERO

func _physics_process(delta):
	if direction != Vector2.ZERO:
		velocity = direction * speed * delta
		global_position += velocity

func set_direction(new_direction):
	self.direction = new_direction

func _on_body_entered(body):
	if body.has_method("take_damage") and body.get_team() != team:
		body.take_damage(20)
	
	if body.has_method("set_state") and body.get_state() != CharacterState.ATTACK and body.get_team() != team:
		body.set_state(CharacterState.HIT)
		var hit_direction = body.global_position.direction_to(global_position - velocity * 20)
		body.move_pos = global_position + (hit_direction * body.global_position.distance_to(body.end_of_fov.global_position))
	
	queue_free()
