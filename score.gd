extends RichTextLabel
@onready var player = get_parent().get_parent().get_node("Player")

var score = 0
var combo
func _physics_process(delta):

	score = player.score
	combo = player.combo
	text = "[right]Score: {score} [/right]".format({"score":str(int(score))}) #maybe do all this in the player script
	
	if combo != 0:
		text = "[right]Score: {score} + {combo}[/right]".format({"score":str(int(score)),"combo":str(int(combo))})
