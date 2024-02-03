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

var enemy  = null
var target = null
var weapon = null

@onready var detection_zone = $DetectionZone
@onready var fov			= $DetectionZone/FOV

func set_weapon(new_weapon):
	enemy = get_parent()
	weapon = new_weapon

func _ready():
	pass # Replace with function body.

func _process(_delta):
	match state:
		State.IDLE:
			pass
		State.ATTACK:
			if target != null and weapon != null:
				var direction = weapon.global_position.direction_to(target.global_position).angle()
				weapon.rotation 		= direction
				detection_zone.rotation = direction + 1.75
				if $Cooldown.is_stopped():
					weapon.shoot()
					$Cooldown.start()

func _on_detection_zone_body_entered(body):
	if body.is_in_group("Player"):
		state = State.ATTACK
		target = body
	emit_target.emit(target)

func _on_detection_zone_body_exited(body):
	state = State.IDLE
	if target == body:
		target = null
	emit_target.emit(target)
