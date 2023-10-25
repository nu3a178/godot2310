extends Label

var maxhp
# Called when the node enters the scene tree for the first time.
func _ready():
	maxhp = $"../../Enemy".hp
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = str($"../../Enemy".hp)+"/"+str(maxhp)
	pass
