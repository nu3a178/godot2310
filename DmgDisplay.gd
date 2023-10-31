extends Node2D

var dLabel = preload("res://scenes/damage_label.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func showDmg(value,type,pos):
	
	var l = dLabel.instantiate()
	l.damage_of = type
	l.dValue = value
	l.position = pos
	print("ダメージ表示"+str(value)+type)
	add_child(l)
