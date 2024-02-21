extends Character

class_name Ally

signal find_allies
signal ally_loaded(ally: Ally)

@onready var camera = $Camera

var allies_in_range: int = -1
var last_seen_ally: Ally

func _save(save_file: ConfigFile):
	super(save_file)
	
	save_file.set_value(name, "allies_in_range", allies_in_range)
	save_file.set_value(name, "last_seen_ally", inst_to_dict(last_seen_ally))

func _load(save_file: ConfigFile, p_section):
	super(save_file, p_section)
	
	if save_file.has_section_key(p_section, "last_seen_ally"):
		last_seen_ally = dict_to_inst(save_file.get_value(p_section, "last_seen_ally"))
	
	allies_in_range = save_file.get_value(p_section, "allies_in_range")
	
	ally_loaded.emit(self)

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

func _on_staying_range_body_exited(body):
	if (
			!body.has_method("get_team")  
			or body.get_team() != team.team
	):
		return
	
	allies_in_range -= 1
	
	last_seen_ally = body
