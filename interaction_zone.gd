extends Area3D
@onready var interact_prompt = get_parent().get_parent().get_node("HUD/textbox") 
@onready var player = get_parent().get_parent().get_node("Player")
var player_in_zone = false

@export var interactable_type = ""


func _on_body_entered(body):
	if body.name == "Player":
		player_in_zone = true
		if interactable_type == "quicksand":
			player.SPEED = 5
			player.inquicksand = true
		if interactable_type == "wall_runnable":
			player.gravity = 0
			player.velocity.y = 0
			print(player.gravity)
		




func _on_body_exited(body):
	if body.name == "Player":
		player_in_zone = false
		if interactable_type == "quicksand":
			player.SPEED = 30
			player.inquicksand = false
		if interactable_type == "wall_runnable":
			player.gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
			player.in_wallrun = 0
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	interact_prompt.text = ""
func _process(delta):
	if player_in_zone:
		interact_prompt.text = "[center]E TO INTERACT[/center]"
		if interactable_type == "quicksand" and Input.is_action_just_pressed("interact"):
			DialogueManager.show_example_dialogue_balloon(load("res://walltest.dialogue"),"this_is_a_node_title")
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			player.sanity -= 25
		if interactable_type == "wall_runnable":
			player.gravity = move_toward(0,9.8,0.9)
			player.in_wallrun = 1
			if Input.is_action_just_pressed("interact"):
				DialogueManager.show_example_dialogue_balloon(load("res://actual_wall.dialogue"),"wall")
				player.sanity -= 50
			if Input.is_action_just_pressed("jump"):
				player.velocity.y = move_toward(player.velocity.y,0,2)
				# code to make diagonal jump when on walls or remove the above to auto-scale the wall in one jump
				
				
			
