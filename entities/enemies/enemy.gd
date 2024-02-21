extends Character

class_name Enemy

signal follow_path
signal enemy_loaded

var path: Path2D
@export var score_worth: int

var path_to_follow: PathFollow2D

func _save(save_file: ConfigFile):
	super(save_file)
	
	save_file.set_value(name, "path_to_follow", inst_to_dict(path_to_follow))

func _load(save_file: ConfigFile, p_section):
	super(save_file, p_section)
	
	if save_file.has_section_key(p_section, "path_to_follow"):
		path_to_follow = dict_to_inst(save_file.get_value(p_section, "path_to_follow"))
	
	enemy_loaded.emit(self)

func _ready():
	super()

func _physics_process(delta):
	super(delta)
