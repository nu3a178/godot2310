extends Node2D

var dValue
var l 
var color 
# Called when the node enters the scene tree for the first time.
	
func _ready():
	l = $"Label"
	l.text = str(dValue)
	l.modulate = color


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += Vector2(0,-30*delta)
	pass



func _on_timer_timeout():
	queue_free()

