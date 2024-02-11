extends CharacterBody2D

class_name Character

signal died

var state = CharacterState.IDLE:
	set(new_state):
		if new_state == state:
			return
		state = new_state
	get:
		return state

func set_state(p_state):
	state = p_state
	
func get_state():
	return state

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

@onready var detection_zone = $DetectionZone
@onready var fov			= $DetectionZone/FOV
@onready var end_of_fov		= $DetectionZone/EndOfFOV

@onready var weapon   		= $Gun
@onready var barrel     	= $Gun/GunBarrel
@onready var weapon_sprite 	= $Gun/GunSprite

@onready var animations = $AnimationPlayer
@onready var sprite 	= $CharacterSprite

@onready var team			= $Team
@onready var shoot_cooldown = $Cooldown

var move_pos := Vector2.ZERO

@export var speed: int = 300
@export var rotation_speed = PI * 1.1

var targets_queue := Array()
var potential_targets := Array()

var target = null
var target_distance = -1

@export var health: int = 100

func _ready():
	pass

func get_team():
	return team.team

func set_target(new_target):
	target = new_target
	
func get_target():
	return target

func set_move_pos(new_pos):
	move_pos = new_pos

func _physics_process(_delta):
	if potential_targets:
		track_target(potential_targets[0])
	
	nav_agent.set_velocity(velocity)
	animate()

func animate():
	if velocity == Vector2.ZERO:
		animations.play("idle")
	else: 
		animations.play("run")
	
	if barrel.global_position.x - self.global_position.x < 0:
		weapon_sprite.flip_v = true
		weapon_sprite.offset = Vector2(0, -2)
		sprite.flip_h = true
	else:
		weapon_sprite.flip_v = false
		weapon_sprite.offset = Vector2(0, 2)
		sprite.flip_h = false

func _on_detection_zone_body_entered(body):
	if (
			!body.has_method("get_team")  
			or body.get_team() == team.team
	):
		return
	
	potential_targets.push_front(body)

func _on_detection_zone_body_exited(body):
	if (
			body.has_method("get_team") == false
			or body.get_team() == team.team
	):
		return
	
	var idx = potential_targets.find(body)
	if idx != -1:
		targets_queue.pop_at(idx)
		print("cat")
	
	if target != body:
		idx = targets_queue.find(body)
		if idx == -1:
			print("Error this shouldn't happen for the enemy")
			return 
		targets_queue.pop_at(idx)
	
	if target and target == body:
		if targets_queue.size() == 1:
			targets_queue.pop_front()
			target = null
			state = CharacterState.IDLE
		else:
			targets_queue.pop_front()
			target = targets_queue[0]
		target = target

func track_target(body):
	if body == null:
		return
	
	var ray = create_ray(global_position, body.global_position)
	
	if (ray["collider"] != body):
		return
	
	potential_targets.pop_front()
	targets_queue.append(body)
	
	if target == null:
		target = targets_queue[0]
		target = target
		_on_nav_update_timeout()
	state = CharacterState.ATTACK
	pass

func turn_to(pos, p_rotation_speed = PI):
	var final_pos = weapon.global_position.direction_to(pos)
	var angle = lerp_angle(weapon.rotation, final_pos.angle(), 1)
	var direction = clamp(angle, weapon.rotation - p_rotation_speed, weapon.rotation + p_rotation_speed)
	weapon.rotation = direction
	detection_zone.rotation = weapon.rotation + PI/2

func take_damage(damage):
	health -= damage
	if health <= 0:
		died.emit(self)
		queue_free()

func get_move_direction() -> Vector2:
	return global_position.direction_to(nav_agent.get_next_path_position())

func _on_nav_update_timeout():
	if target != null:
		nav_agent.target_position = target.global_position

func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity

func create_ray(from: Vector2, to: Vector2):
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(from, to)
	query.exclude = [self]
	return space_state.intersect_ray(query)
