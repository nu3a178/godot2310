extends Node2D

var melee_rotation = PI
var gun_rotation = 0
var target_rotation
var angular_speed = -4*PI
var current_rotation
# Called when the node enters the scene tree for the first time.
func _ready():
	current_rotation = rotation
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $"../Player".attackType =="melee":
		target_rotation = melee_rotation
	elif $"../Player".attackType =="gun":
		target_rotation = gun_rotation

	if snapped(current_rotation,0.2) == snapped(target_rotation,0.2):
		rotation = target_rotation
	else:
		rotation += delta*angular_speed
		current_rotation +=delta*angular_speed
		if current_rotation <0:
			current_rotation +=2*PI
