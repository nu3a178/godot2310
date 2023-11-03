extends Node2D

var direction 
const SPEED = 1000
var v
var pos
@export var atk = 1
var spr 
var bLog 
# Called when the node enters the scene tree for the first time.
func _ready():
	direction = $"../../Player".looking_at
	v=Vector2(0,0)
	pos =$"../gun_weapon".get_global_position()
	set_global_position(pos)
	spr = $"Sprite2D"
	bLog = $"../../UI/BattleLog"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	v = Vector2(delta*SPEED*direction,0)
	pos += v

	set_global_position(pos)

	

	
	


func _on_area_2d_body_entered(body):
	bLog.addLog("射撃が"+body.name+"に当たった")
	if body.TYPE =="enemy":
		body.decreaseHp(int(atk*0.95 + (atk*0.1)*randf()))
	queue_free()
	


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	pass # Replace with function body.
