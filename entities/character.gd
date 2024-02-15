extends CharacterBody2D

class_name Character

signal died
signal commenced_attack
signal got_hit

var state := CharacterState.IDLE:
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

@onready var animations = $AnimationPlayer
@onready var sprite 	= $CharacterSprite

@onready var team			= $Team
@onready var shoot_cooldown = $Cooldown

@onready var weapon_component: WeaponComponent = $WeaponComponent
@onready var weapon

var targets_queue := Array()
var potential_targets := Array()
var potential_target_idx: int = 0

var target = null
var target_pos: Vector2
var target_distance = -1

@export var health: int = 100
@export var speed: int = 300
@export var rotation_speed = PI * 1.1

func _ready():
	weapon_component.set_team(team.team)
	weapon = weapon_component.get_current_weapon()

func get_team():
	return team.team

func set_target(new_target):
	target = new_target
	
func get_target():
	return target

func _physics_process(_delta):
	if !potential_targets.is_empty():
		potential_target_idx %= potential_targets.size()
		print(potential_target_idx, " ", potential_targets.size())
		track_potential_target(potential_targets[potential_target_idx])
		potential_target_idx += 1
	
	track_target()
	
	nav_agent.set_velocity(velocity)
	animate()

func animate():
	if velocity == Vector2.ZERO:
		animations.play("idle")
	else: 
		animations.play("run")
	
	if weapon.barrel.global_position.x - self.global_position.x < 0:
		weapon.sprite.flip_v = true
		weapon.sprite.offset = Vector2(0, -weapon.offset)
		sprite.flip_h = true
	else:
		weapon.sprite.flip_v = false
		weapon.sprite.offset = Vector2(0, 0)
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
		potential_targets.pop_at(idx)
	elif target != body:
		idx = targets_queue.find(body)
		if idx == -1:
			print("Error this shouldn't happen for the enemy")
			return 
		targets_queue.pop_at(idx)
	
	if target and target == body:
		if targets_queue.size() <= 1:
			targets_queue.pop_front()
			target = null
		else:
			targets_queue.pop_front()
			target = targets_queue[0]

func track_potential_target(body):
	if body == null:
		return
	
	var ray = create_ray(global_position, body.global_position)
	
	if (ray["collider"] != body and !ray.is_empty()):
		return
	
	potential_targets.pop_at(potential_targets.find(body))
	targets_queue.append(body)
	
	if target == null:
		target = targets_queue[0]
		target = target
		_on_nav_update_timeout()
	
	commenced_attack.emit()

func track_target():
	if target == null:
		return
		
	var ray = create_ray(global_position, target.global_position)
	
	if (ray["collider"] != target):
		if targets_queue.size() <= 1:
			targets_queue.pop_front()
			potential_targets.push_front(target)
			_on_nav_update_timeout()
			target = null
		else:
			targets_queue.pop_front()
			potential_targets.push_front(target)
			target = targets_queue[0]
			_on_nav_update_timeout()


func turn_to(p_target, p_rotation_speed = PI):
	match typeof(p_target):
		TYPE_FLOAT:
			turn_to_angle(p_target, p_rotation_speed)
		TYPE_VECTOR2:
			var turn_angle = weapon.global_position.direction_to(p_target).angle()
			turn_to_angle(turn_angle, p_rotation_speed)
		_:
			return 

func turn_to_angle(p_angle: float, p_rotation_speed = PI):
	var angle = lerp_angle(weapon.rotation, p_angle, 1)
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
	
func get_next_pos() -> Vector2:
	return nav_agent.get_next_path_position()

func _on_nav_update_timeout():
	if target != null:
		nav_agent.target_position = target.global_position

func set_nav_agent_target_pos(p_pos):
	nav_agent.target_position = p_pos
	
	if !nav_agent.is_target_reachable():
		nav_agent.target_position = nav_agent.get_final_position() 

func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	clamp(velocity, Vector2.ZERO, safe_velocity)
	velocity = velocity as Vector2i

func create_ray(from: Vector2, to: Vector2) -> Dictionary:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(from, to, collision_mask ^ collision_layer, [self])
	return space_state.intersect_ray(query)

func get_hit_from(p_hit_from: Vector2):
	if state == CharacterState.ATTACK or state == CharacterState.PLAYER:
		return
	
	set_move_target(p_hit_from)
	
	got_hit.emit()

func set_move_target(p_tp: Vector2):
	var move_distance = global_position.distance_to(end_of_fov.global_position)
	target_pos = global_position + move_distance * p_tp.normalized()
	var ray: Dictionary = create_ray(global_position, target_pos)
	
	if !ray.is_empty():
		target_pos = ray["position"]
	
	set_nav_agent_target_pos(target_pos)
