extends State

class_name StatePlayer

@export var player_texture: Texture
@export var ally_texture:	Texture

func _ready():
	pass

func enter():
	character.state = CharacterState.PLAYER
	character.sprite.texture = player_texture
	
func exit():
	character.sprite.texture = ally_texture

func update(_delta):
	character.velocity = Vector2.ZERO
	
	if Input.is_action_pressed("shoot"):
		character.weapon.shoot()
	
	if Input.is_action_pressed("move_up"):
		character.velocity.y = -1;
	if Input.is_action_pressed("move_down"):
		character.velocity.y = 1
	if Input.is_action_pressed("move_left"):
		character.velocity.x = -1
	if Input.is_action_pressed("move_right"):
		character.velocity.x = 1
	
	character.velocity = character.velocity.normalized() * character.speed
	character.move_and_slide()
	
	character.turn_to(character.get_global_mouse_position())

func _unhandled_input(event):
	if event.is_action_released("shoot") and character.state == CharacterState.PLAYER:
		character.weapon.shoot()
		get_viewport().set_input_as_handled()

