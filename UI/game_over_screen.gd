extends CanvasLayer

func _ready():
	pass

func _on_new_game_pressed():
	get_tree().change_scene_to_file("res://main.tscn")

func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")

func _on_quit_pressed():
	get_tree().quit()
