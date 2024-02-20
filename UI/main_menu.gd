extends CanvasLayer

const MainScene = preload("res://main.tscn")

func _ready():
	pass

func _on_new_game_pressed():
	get_tree().change_scene_to_packed(MainScene)

func _on_quit_pressed():
	get_tree().quit()
