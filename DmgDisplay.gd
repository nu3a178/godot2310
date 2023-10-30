extends Node2D

var dLabel = preload("res://damage_label.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func showDmg(value,type,pos):
	
	var l = dLabel.instantiate()
	var color
	if value ==0:
		color = Color(0.4, 0.4, 0.4, 1)
	elif type =="enemy":
		color = Color(1,1,0,1)	
	elif type =="player":
		color = Color(1,0,0,1)	
	elif type =="regain":
		color = Color(0,1,0,1)	

	l.color = color
	l.dValue = value
	l.position = pos
	add_child(l)
