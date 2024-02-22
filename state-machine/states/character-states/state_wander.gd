extends State

class_name StateWander

func _ready():
	state_name = CharacterState.WANDER
	
func enter():
	super()
	
	await get_tree().create_timer(0.1).timeout 
	
	if character == null:
		return
	
	character.set_nav_agent_target_pos(Vector2(randi_range(-1000, 1000), randi_range(-1000, 1000)))

func exit():
	pass
	
func update(_delta):
	if character == null:
		return
	
	if character.nav_agent.is_target_reached():
		var ray = character.create_ray(character.global_position, character.velocity * 2000)
		
		if ray.is_empty():
			return
		
		if character.global_position.distance_to(ray["position"]) < 60:
			character.velocity = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * character.speed
			character.set_move_target(character.velocity * 2000)
		else:
			var rand_position = Vector2(randi_range(-100, 100), randi_range(-100, 100))
			character.set_nav_agent_target_pos(character.global_position + rand_position)
	
	character.turn_to(character.nav_agent.target_position)
	character.velocity = character.get_move_direction() * character.speed
	character.move_and_slide()
