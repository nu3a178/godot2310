extends ProgressBar

var plr 
# Called when the node enters the scene tree for the first time.
func _ready():
	plr = $"../Player"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	visible = plr.is_reloading
	value = (plr.reloadProgress/plr.reloadSpan)*100
	pass
