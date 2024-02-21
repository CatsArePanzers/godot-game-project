extends Node

@export var path: 	  String = "user://save.cfg"
@export var password: String = "kotkamql"

var main_scene_file_path: String
var main_scene_path: String
var main_scene: Main

func _save():
	var config = ConfigFile.new()
	
	config.set_value("main_scene_file_path", "main_scene_file_path", main_scene_file_path)
	
	await main_scene._save(config)
	
	config.save(path)

func _load():
	var config = ConfigFile.new()
	
	if config.load(path) != OK:#_encrypted_pass(path, password) != OK:
		return
	
	main_scene_file_path = config.get_value("main_scene_file_path", "main_scene_file_path")
	
	main_scene = SceneSwitcher.goto_scene(main_scene_file_path)
	
	var sections = config.get_sections()
	sections.remove_at(sections.find("main_scene_file_path"))
	
	await main_scene._load(config, sections)
