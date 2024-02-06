extends ColorRect

func _process(delta):
	if get_parent().text == "":
		color = Color(1,1,1,0)
	else:
		color =  Color(0.47,0.66,0.58,1)
