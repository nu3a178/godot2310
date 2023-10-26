extends Node2D

var direction 
const SPEED = 1000
var screensize 
var v
var pos
@export var atk = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	direction = $"../../../Player".looking_at
	screensize = $"../../../Player".screen_size
	v=Vector2(0,0)
	pos =$"../../gun_weapon".get_global_position()
	set_global_position(pos)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	v = Vector2(delta*SPEED*direction,0)
	pos += v
	set_global_position(pos)
	
	if global_position.x < 0 or screensize.x < global_position.x :
		queue_free()
	
	


func _on_area_2d_body_entered(body):
	print("射撃が"+body.name+"に当たった")
	if body.name =="Enemy":
		body.decreaseHp(atk)
	queue_free()
	
