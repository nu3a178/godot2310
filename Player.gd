extends CharacterBody2D

#behavior:キャラクターの動作状態。
#	[name]:動作状態の名称。
#	[duration]:その状態になってから経過した時間。
var behavior = {"name":"init","duration":0}
var is_dashing = {"is":false,"duration":0,"cooldown":0}
var dash_tired = {"is":false,"duration":0}
var screen_size 
const SPEED = 300
var speed = 300.0
@export var maxStamina = 10
var stamina = maxStamina
var time_notUsingStamina = 0
@export var time_gainStamina = 2
@export var speed_gainStamina = 2
const JUMP_VELOCITY = -500.0
var looking_at =1
var direction = 0
var weapon_melee = preload("res://melee_weapon.tscn")
var weapon_gun = preload("res://gun_weapon.tscn")
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var allAttackTypes = ["melee","gun"]
var attackType 
func _ready():
	screen_size = get_viewport_rect().size
	print(screen_size)
	attackType = allAttackTypes[0]
	
	
func _physics_process(delta):
	behavior.duration += delta 
	time_notUsingStamina +=delta
	
	if time_notUsingStamina > time_gainStamina and stamina < maxStamina:
		stamina += speed_gainStamina*delta
	if stamina > maxStamina:
		stamina = maxStamina
	#通常の状態では、強制的に速度を一定に保つ。
	if not is_dashing.is and not dash_tired.is:
		speed =SPEED
	dashing(delta)
	
	if Input.is_action_just_pressed("change_weapon"):
		change_weapon()
	if Input.is_action_just_pressed("attack"):
		attack()
		
			
		
		
	# Add the gravity.
	
	if not is_on_floor():
		$AnimatedSprite2D.animation = "jump"
		velocity.y += gravity * delta
	else:
		$AnimatedSprite2D.animation = "idle"
		switch_behavior("idle")

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		switch_behavior("jump")
		velocity.y = JUMP_VELOCITY

	# 移動、および向いている方向について
	if Input.is_action_pressed("move_left"):
		direction = -1
	elif Input.is_action_pressed("move_right"):
		direction = 1
	else:
		direction = 0
		
	if direction != 0 and not Input.is_action_pressed("aim"):
		looking_at = direction
	
	#Playerの位置制限
	if direction < 0 and 0 < position.x or 0 < direction  and position.x < screen_size.x :
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	
#dashing:ダッシュに関連するメソッド。
func dashing(delta):
	
	#ダッシュ時のスピード倍率。
	var dash_rate = 5.0
	#"is_dashing"がtrueでないときに、ダッシュに割り当てられたボタンが押されたなら、
	#"is_dashing"がtrueになり、スピードがdash_rateだけ乗算される。
	if Input.is_action_just_pressed("dash") and stamina >= 2 and not is_dashing.is :
		speed *= dash_rate
		stamina -=2
		time_notUsingStamina = 0
		is_dashing.is = true
		
	#"is_dash"がtrueの状態が0.15秒持続したら、"dash_tired"がtrueになり、スピードが元の値の半分になる。
	if is_dashing.is :
		is_dashing.duration +=delta
		if is_dashing.duration >0.15:
			is_dashing.is = false
			is_dashing.duration = 0
			dash_tired.is = true
			speed /= (dash_rate*2)
	
	#"dash_tired"がtrueの状態が0.2秒持続したら、スピードを元に戻す。
	if dash_tired.is :
		dash_tired.duration += delta
		if dash_tired.duration > 0.2:
			dash_tired.is = false
			dash_tired.duration = 0
			speed *= 2
	
#動作切り替え。
#arg:n 切り替えたい動作の名前。 
func switch_behavior(n):
	if behavior.name != n:
		behavior.name = n
		behavior.duration = 0
		print("動作が切り替わりました:"+n)
		
		
func attack():
	match attackType:
		"melee":
			var atk =weapon_melee.instantiate()
			if looking_at > 0:
				atk.rotate_reverse = true
			add_child(atk)
		"gun":
			pass
	
func change_weapon():
	var before = attackType
	var i = allAttackTypes.find(attackType)+1
	if i > len(allAttackTypes)-1:
		i = 0
	attackType = allAttackTypes[i]
	var after = attackType
	print("武器変更:"+before+"→"+after)
	
	if attackType == "gun":
		var gun = weapon_gun.instantiate()
		add_child(gun)
	else :
		print("gunを削除")
		remove_child($"gun_weapon")
	
