extends Character

class_name Ally

signal find_allies

@onready var camera = $Camera

var allies_in_range: int = -1
var last_seen_ally: Ally

func _ready():
	super()

func _physics_process(delta):
	super(delta)
	
	if allies_in_range < 1:
		if state != CharacterState.ATTACK:
			find_allies.emit()

func get_camera():
	return camera

func _on_staying_range_body_entered(body):
	if (
			!body.has_method("get_team")  
			or body.get_team() != team.team
	):
		return

	allies_in_range += 1
	
	#print(body)
	#print(allies_in_range)

func _on_staying_range_body_exited(body):
	if (
			!body.has_method("get_team")  
			or body.get_team() != team.team
	):
		return
	
	allies_in_range -= 1
	
	last_seen_ally = body
	
	#print(last_seen_ally_pos)
	
	#print(body)
	#print(allies_in_range)

