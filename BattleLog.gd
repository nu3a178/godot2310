extends Node2D

var textLog = [""]
var logView = [""]
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func addLog(t:String):
	print(t)
	textLog.append(t)
	logView = textLog.slice(-10)
	$"Label".text = "\n".join(logView)
