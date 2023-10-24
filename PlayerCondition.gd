extends Label

var conditions =["","","","",""]
var format_string = "%*.*f"
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	conditions[0]=("behavior: "+$"../../Player".behavior.name)
	conditions[1]=("duration: "+format_string %[5,3,$"../../Player".behavior.duration])
	conditions[2]=("speed :"+str($"../../Player".speed))
	conditions[3]=("dashing :"+str($"../../Player".is_dashing))
	conditions[4]=("dash_tired :"+str($"../../Player".dash_tired))
	text = "\n".join(conditions)
