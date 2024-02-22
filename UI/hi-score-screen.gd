extends CanvasLayer

@export var main_menu_scene_path = "res://ui/main_menu.tscn"

var score_counter: ScoreCounter

func set_score_counter(p_score_counter):
	score_counter = p_score_counter

func _ready():
	get_tree().paused = true

func _on_main_menu_pressed():
	SceneSwitcher.goto_scene(main_menu_scene_path)

func _on_quit_pressed():
	get_tree().quit()

func _on_tree_exiting():
	get_tree().paused = false

func _on_line_edit_text_submitted(new_text):
	score_counter.hi_score_name = new_text
	score_counter.save_hi_score()
	_on_main_menu_pressed()
