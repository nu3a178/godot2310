extends ProgressBar

var maxHp
# Called when the node enters the scene tree for the first time.
func _ready():
	maxHp = $"../".hp
	max_value = maxHp
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	value = $"../".hp
	pass
