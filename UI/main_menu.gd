extends CanvasLayer

@export var main_scene_path = "res://main.tscn"

func _on_new_game_pressed():
	SceneSwitcher.goto_scene(main_scene_path)

func _on_load_pressed():
	SaveAgent._load()

func _on_quit_pressed():
	get_tree().quit()
