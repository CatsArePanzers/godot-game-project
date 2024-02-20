extends CanvasLayer

func _ready():
	get_tree().paused = true

func _on_save_pressed():
	pass 

func _unhandled_key_input(event):
	if event.is_action_pressed("pause") and get_tree().paused == true:
		get_viewport().set_input_as_handled()
		_on_resume_pressed()

func _on_main_menu_pressed():
	#print("cat")
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")

func _on_quit_pressed():
	get_tree().quit()

func _on_resume_pressed():
	queue_free()

func _on_tree_exiting():
	get_tree().paused = false
