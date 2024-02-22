extends Control

class_name HealthBarComponent

@onready var health_bar: ProgressBar = $HealthBar

func set_health(new_health):
	health_bar.value = new_health

func set_max_health(p_max_health):
	health_bar.max_value = p_max_health
