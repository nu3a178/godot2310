extends Node2D

var plr
var types 
var plr_equipping
var target_rotation = {}
var angular_speed = -4*PI
var rotateSpan
var t
# Called when the node enters the scene tree for the first time.
func _ready():
	plr = $"../Player"
	types = plr.allAttackTypes
	rotateSpan = (2*PI)/len(types)
	var tar = 0
	for i in range(len(types)):
		target_rotation[types[i]] = tar
		tar += rotateSpan
	
	print(target_rotation)
	rotation = 0
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if plr != null:
		plr_equipping = plr.attackType
		if snapped(rotation,0.3) == snapped(target_rotation[plr_equipping],0.3):
			rotation = target_rotation[plr_equipping]
		else:
			rotation += delta*angular_speed
			if rotation <0:
				rotation += 2*PI
