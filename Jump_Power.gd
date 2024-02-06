extends RichTextLabel
@onready var in_quicksand = get_parent().get_parent().get_node("Player")
var jump_power = 0

func _process(delta):
	if Input.is_action_pressed("sprint") and !(in_quicksand.inquicksand):
		jump_power += 0.05
		jump_power = clamp(jump_power,0,5)
		text = "[center] Jump Power: " + str(int((jump_power/5)*100)) + "%[/center]"
	elif in_quicksand.inquicksand:
		text = "[center] IN QUICKSAND [/center]"
	else:
		text = ""
		jump_power = 0 
	
