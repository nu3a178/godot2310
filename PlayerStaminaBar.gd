extends ProgressBar

var current 
var l 
var m
var format_string = "%*.*f"
# Called when the node enters the scene tree for the first time.
func _ready():
	l = $"Label"
	m = $"../Player".maxStamina
	max_value = m
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	current = $"../Player".stamina
	value = current
	l.text = format_string %[5,1,current]+"/"+str(m)
	pass
