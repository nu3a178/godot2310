extends Node2D

var dValue
var l 
var color 
# Called when the node enters the scene tree for the first time.
	
func _ready():
	l = $"Label"

	if damage_of =="enemy":
		l.label_settings.font_color = Color(1,1,1,255)	
	elif damage_of =="player":
		l.label_settings.font_color = Color(255,0,0,255)	
	elif damage_of =="regain":
		l.label_settings.font_color = Color(0,255,0,255)	
		
	l.text = str(dValue)
	l.modulate = color


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += Vector2(0,-30*delta)
	pass



func _on_timer_timeout():
	queue_free()

