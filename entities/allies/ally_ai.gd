extends Node2D

class_name AllyAI

signal emit_target(target)

var state = CharacterState.IDLE:
	set(new_state):
		if new_state == state:
			return
		state = new_state
	get:
		return state
		
var parent = null
var target = null
var weapon = null

var targets_queue = Array()

@onready var detection_zone = $DetectionZone
@onready var fov			= $DetectionZone/FOV
@onready var end_of_fov		= $DetectionZone/EndOfFOV

@onready var hit_from = Vector2()

@export var rotation_speed = PI * 0.8

func set_weapon(new_weapon):
	parent = get_parent()
	weapon = new_weapon

func _ready():
	pass # Replace with function body.

func _process(delta):
	match state:
		CharacterState.IDLE:
			pass
		CharacterState.HIT:
			if target != null:
				state = CharacterState.ATTACK
				pass
			
			turn_to(hit_from, rotation_speed * delta * 10)
			
			var angle = weapon.global_position.direction_to(hit_from).angle()
			if (
					parent.get_target() != end_of_fov
					and fmod(abs(weapon.global_rotation - angle), PI * 1.99) <= PI/18
			):
				emit_target.emit(end_of_fov)
				
		CharacterState.ATTACK:
			if target == null or weapon == null:
				pass
				
			turn_to(target.global_position, rotation_speed * delta)
				
			var angle = weapon.global_position.direction_to(target.global_position).angle()
			if (
					$Cooldown.is_stopped() 
					and fmod(abs(weapon.global_rotation - angle), PI * 1.99) <= PI/18
			):
				weapon.shoot()
				$Cooldown.start()

func _on_detection_zone_body_entered(body):
	if (
			body.has_method("get_team")  
			and body.get_team() != parent.team.team
	):
		targets_queue.append(body)
		#print("Ally added: ", targets_queue.size())
		if target == null:
			target = targets_queue[0]
			emit_target.emit(target)
		state = CharacterState.ATTACK

func _on_detection_zone_body_exited(body):
	if (
			body.has_method("get_team") == false
			or body.get_team() == parent.team.team
	):
		return
	
	if target != body:
		var idx = targets_queue.find(body)
		if idx == -1:
			print("Error this shouldn't happen for the ally")
			return 
		targets_queue.pop_at(idx)
		#print("ally removed: ", targets_queue.size())
	
	if target and target == body:
		#print("ally removed: ", targets_queue.size())
		if targets_queue.size() <= 1:
			targets_queue.pop_front()
			target = null
			state = CharacterState.IDLE
		else:
			targets_queue.pop_front()
			target = targets_queue[0]
		emit_target.emit(target)

func turn_to(pos, p_rotation_speed = self.rotation_speed):
	var final_pos = weapon.global_position.direction_to(pos)
	var angle = lerp_angle(weapon.rotation, final_pos.angle(), 1)
	var direction = clamp(angle, weapon.rotation - p_rotation_speed, weapon.rotation + p_rotation_speed)
	weapon.rotation = direction
	detection_zone.rotation = weapon.rotation + PI/2
