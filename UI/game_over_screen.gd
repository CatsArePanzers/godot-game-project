extends CanvasLayer

@export var main_scene_path = "res://main.tscn"
@export var main_menu_scene_path = "res://ui/main_menu.tscn"

func _ready():
	pass

func _on_new_game_pressed():
	SceneSwitcher.goto_scene(main_scene_path)

func _on_main_menu_pressed():
	SceneSwitcher.goto_scene(main_menu_scene_path)

func _on_quit_pressed():
	get_tree().quit()
