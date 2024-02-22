extends Node

var current_scene = null

func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

func goto_scene(path):
	current_scene.queue_free()

	var s = ResourceLoader.load(path)

	current_scene = s.instantiate()

	get_tree().root.add_child(current_scene)

	get_tree().current_scene = current_scene

	return get_tree().current_scene
