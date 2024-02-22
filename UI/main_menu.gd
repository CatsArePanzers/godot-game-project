extends CanvasLayer

@export var main_scene_path = "res://main.tscn"

func _on_new_game_pressed():
	await SceneSwitcher.goto_scene(main_scene_path)
	#get_tree().change_scene_to_file(main_scene_path)

func _on_load_pressed():
	SaveAgent._load()

func _on_quit_pressed():
	get_tree().quit()
