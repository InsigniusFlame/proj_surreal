extends RichTextLabel
@onready var player = get_parent().get_parent().get_node("Player")


func _process(delta):

	if player.velocity.y < -80 and player.velocity.y > -100:
		text = "[color=Yellow]VELOCITY_Y: {velo} [/color]".format({"velo":str(int(player.velocity.y))})
	elif player.velocity.y < -100:
		text = "[color=Red]VELOCITY_Y: {velo} [/color]".format({"velo":str(int(player.velocity.y))})
	else:
		text = "VELOCITY_Y: " + str(int(player.velocity.y))
	
