extends Area2D

class_name Bullet

const VECTOR_LENGTH = 2000000000

var direction := Vector2.ZERO
var velocity  := Vector2.ZERO
var speed: 		 int = 1000
var damage: 	 int
var team: 		 int

@export var piercing: int = 1

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
		return
	
	if body.has_method("take_damage"):
		body.take_damage(damage)
	
	if body.has_method("get_state"):
		body.get_hit_from(body.global_position - direction * VECTOR_LENGTH)
	
	piercing -= 1
	
	if piercing <= 0:
		queue_free()

func _save(save_file: ConfigFile):
	save_file.set_value(name, "scene_path",  scene_file_path)
	save_file.set_value(name, "parent_node_path", get_parent().get_path())
	
	save_file.set_value(name, "global_position", global_position)
	save_file.set_value(name, "direction", direction)
	save_file.set_value(name, "speed", speed)
	save_file.set_value(name, "damage", damage)
	save_file.set_value(name, "team", team)
	save_file.set_value(name, "piercing", piercing)

func _load(save_file: ConfigFile, p_section):
	global_position = save_file.get_value(p_section, "global_position")
	direction = save_file.get_value(p_section, "direction")
	speed = save_file.get_value(p_section, "speed")
	damage = save_file.get_value(p_section, "damage")
	team = save_file.get_value(p_section, "team")
	piercing = save_file.get_value(p_section, "piercing")
