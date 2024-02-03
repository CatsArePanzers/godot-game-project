extends Node2D

enum State{
	IDLE,
	ATTACK
}

signal emit_target(target)

var state = State.IDLE:
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

@export var rotation_speed = PI * 0.7

func set_weapon(new_weapon):
	parent = get_parent()
	weapon = new_weapon

func _ready():
	pass # Replace with function body.

func _process(delta):
	match state:
		State.IDLE:
			pass
		State.ATTACK:
			if target != null and weapon != null:
				var angle 	  = lerp_angle(weapon.rotation, (weapon.global_position.direction_to(target.global_position)).angle(), 1)
				var direction = clamp(angle, weapon.rotation - (rotation_speed * delta), weapon.rotation + (rotation_speed * delta))
				#print(weapon.rotation, weapon.global_position.direction_to(target.global_position).angle(), direction)
				weapon.rotation = direction
				detection_zone.rotation = weapon.rotation + PI/2
				if $Cooldown.is_stopped():
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
		state = State.ATTACK

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
			state = State.IDLE
		else:
			targets_queue.pop_front()
			target = targets_queue[0]
		emit_target.emit(target)
