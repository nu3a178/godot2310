extends CharacterBody2D


const SPEED = -200.0
const JUMP_VELOCITY = -400.0
var bLog

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction_x = 1
var screen_size
var blood_exp = preload("res://blood_exp.tscn")
var dmgD

@export var hp = 100
const TYPE = "enemy"
func _ready():
	screen_size = get_viewport_rect().size
	bLog = $"../../BattleLog"
	dmgD = $"../../DmgDisplay"
	
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if position.x <0 or screen_size.x < position.x :
		direction_x *= -1
		$AnimatedSprite2D.flip_h = !$AnimatedSprite2D.flip_h

	velocity.x = SPEED * direction_x
	
	move_and_slide()
	
func decreaseHp(v):
	hp -= v
	bLog.addLog(name+"は"+str(v)+"のダメージを受けた")
	dmgD.showDmg(v,"enemy",position)
	if hp <= 0:
		dead()
		

func dead():
	var explo = blood_exp.instantiate()
	explo.position = position
	explo.position.y -= 50 
	add_sibling(explo)
	bLog.addLog(name+"は死んだ")
	queue_free()
