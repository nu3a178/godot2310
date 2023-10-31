extends ProgressBar

var current 
var l 
var m
var plr
var format_string = "%*.*f"
# Called when the node enters the scene tree for the first time.
func _ready():
	l = $"Label"
	plr =$"../../Player"
	m = plr.maxStamina
	max_value = m
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if plr != null:
		current = plr.stamina
	else:
		current = 0
	value = current
	l.text = format_string %[5,1,current]+"/"+str(m)
	
