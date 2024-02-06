extends CSGBox3D

@onready var player = get_parent().get_node("Player")

func _process(delta):
	if (player.sanity >= 0):
		self.visible = false
		use_collision = false
	elif (player.sanity < -20):
		self.visible = true
		
