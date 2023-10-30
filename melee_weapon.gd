extends Node2D

var rotate_reverse =false
var rotate_init 
var angular_speed = PI
@export var atk = 1
var bLog
# Called when the node enters the scene tree for the first time.
func _ready():
	rotate_init = (-PI/3 if rotate_reverse else -PI*2/3)
	rotation = rotate_init
	bLog =$"../../BattleLog"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if abs(rotation-rotate_init) > PI*2/3:
		queue_free()
	
	rotation += angular_speed *delta*2*(1 if rotate_reverse else -1)
	


func _on_area_2d_body_entered(body):
	bLog.addLog("近接攻撃が"+body.name+"に当たった")
	if body.TYPE =="enemy":
		body.decreaseHp(atk)
	
