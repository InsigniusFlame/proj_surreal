extends Area3D

@onready var player= get_parent().get_parent().get_node("Player")
var on_breakfloor = false


func _on_body_entered(body):
	on_breakfloor = true
	if body.name == "Player" and player.floor_breakable:
		player.velocity.y = 20
		player.in_gpound = false
		player.double_jump = 0
		player.health -= player.falldmg_multiplier * 25
		get_parent().queue_free()
		player.score += 25


		


func _on_body_exited(body):
	on_breakfloor = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

func _process(_delta):
	if on_breakfloor == true and Input.is_action_just_pressed("interact"):
		DialogueManager.show_example_dialogue_balloon(load("res://breakfloor.dialogue"),"breakfloor")
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
