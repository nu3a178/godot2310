extends CharacterBody2D


const SPEED = -200.0
const JUMP_VELOCITY = -400.0
var bLog

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction_x = 1
var screen_size
var blood_exp = preload("res://scenes/blood_exp.tscn")
var dmgD
var cliffDetected = false
var point 
var cDetector 
@export var hp = 100
const TYPE = "enemy"
func _ready():
	screen_size = get_viewport_rect().size
	bLog = $"../UI/BattleLog"
	dmgD = $"../DmgDisplay"
	point = $Node2D
	cDetector = $Node2D/CliffDetector
	
func _physics_process(delta):
	if is_on_floor():
		if cDetector.is_colliding():
			var obj = cDetector.get_collider()
			if obj.TYPE != "Floor":
				cDetector.add_exception(obj)
		else:
			reverse()
			
	if is_on_wall():
		reverse()
	
	if not is_on_floor():
		velocity.y += gravity * delta
	velocity.x = SPEED * direction_x
	
	move_and_slide()
	
func decreaseHp(v):
	hp -= v
	bLog.addLog(name+"は"+str(v)+"のダメージを受けた")
	dmgD.showDmg(v,"enemy",position)
	if hp <= 0:
		dead()
		
func reverse():
	direction_x *= -1	
	$AnimatedSprite2D.flip_h = not $AnimatedSprite2D.flip_h 
	point.position.x *= -1
	cDetector.target_position.x *= -1

func dead():
	var explo = blood_exp.instantiate()
	explo.position = position
	explo.position.y -= 50 
	add_sibling(explo)
	bLog.addLog(name+"は死んだ")
	$"../".decreaseEnemyCount()
	queue_free()
