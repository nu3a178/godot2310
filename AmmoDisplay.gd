extends Node2D

var pro 
var span 
var ammo
# Called when the node enters the scene tree for the first time.
func _ready():
	
	span =$"../Player".reloadSpan
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$"ProgressBar".visible = $"../Player".is_reloading
	pro = $"../Player".reloadProgress
	$"ProgressBar".value = (pro/span)*100  
	$"Label".text = str($"../Player".ammo)
	pass
