extends Node2D

var pro 
var span 
var ammo
var plr
# Called when the node enters the scene tree for the first time.
func _ready():
	plr = $"../../Player"
	span =plr.reloadSpan
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if plr != null:
		pro = plr.reloadProgress
		$"Label".text = str(plr.ammo)
	
