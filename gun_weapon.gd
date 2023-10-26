extends Node2D

var looking_at
var position_init
var gun
# Called when the node enters the scene tree for the first time.
func _ready():
	gun = $"Sprite2D"
	position_init = gun.position.x
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	looking_at = $"../../Player".looking_at
	match looking_at:
		1:
			gun.flip_h = true
			gun.position.x = position_init
		-1:
			gun.flip_h = false
			gun.position.x = -1*position_init
	
