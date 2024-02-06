extends RichTextLabel

@onready var player = get_parent().get_parent().get_node("Player")

func _process(delta):
	text = str(int(player.health))
