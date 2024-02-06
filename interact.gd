extends Area3D
@onready var player = get_parent().get_parent().get_node("Player")
@export var in_quicksand = false

func _on_body_entered(body):
	if body.get_name() == "Player" and player.is_on_floor():
		player.SPEED = 10
		print("woops quicksand")
	in_quicksand = true


func _on_body_exited(body):
	if body.get_name() == "Player":
		player.SPEED = 30
		print("phew")
		in_quicksand = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
		

func _physics_process(delta):
	if player.is_on_floor() and in_quicksand:
		player.SPEED = 10
	if in_quicksand and Input.is_action_just_pressed("interact"):
		DialogueManager.show_example_dialogue_balloon(load("res://walltest.dialogue"),"this_is_a_node_title")
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
