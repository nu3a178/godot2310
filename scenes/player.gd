extends CharacterBody2D
const TYPE = "Player"
@export var hp = 100

@export var maxStamina = 10
var stamina = maxStamina
var time_notUsingStamina = 0
@export var time_gainStamina = 2
@export var speed_gainStamina = 2

#behavior:キャラクターの動作状態。
#	[name]:動作状態の名称。
#	[duration]:その状態になってから経過した時間。
var behavior = {"name":"init","duration":0}

#invinciblity:キャラクターの無敵状態。
#	[is]:無敵状態かどうか。デフォルトではfalse。
#	[duration]:無敵状態になってからの経過時間。
#	[period]:無敵の制限時間。
var invinciblity = {"is":false ,"duration":0,"period":0}

#ダッシュ時のスピード倍率。
var dash_rate = 5.0
var is_dashing = {"is":false,"duration":0,"cooldown":0}
var dash_tired = {"is":false,"duration":0}
var screen_size 

const SPEED = 300
var speed = 300.0



const JUMP_VELOCITY = -700.0
@export var air_jump = 1
var max_air_jump = air_jump

var looking_at =1
var direction = 0

var weapon_melee = preload("res://scenes/melee_weapon.tscn")
var weapon_gun = preload("res://scenes/gun_weapon.tscn")
var bullet = preload("res://scenes/bullet.tscn")
var bld_exp =preload("res://scenes/blood_exp.tscn")

@export var ammo = 10
var magazineAmmo = ammo
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var allAttackTypes = ["melee","gun"]
var attackSpan = {"melee":0.5,"gun":0.3}
var attackPower = {"melee":100,"gun":70}
var time_notAttack = 0
var attackType 

var reloadSpan = 3
var reloadProgress = 0
var is_reloading =false

var bLog 
var dmgD
var ammoLabel
func _ready():
	screen_size = get_viewport_rect().size
	print(screen_size)
	attackType = allAttackTypes[0]
	bLog = $"../UI/BattleLog"
	dmgD = $"../DmgDisplay"
	ammoLabel=$"../UI/EquipDisplay/AmmoDisplay/Label"
	ammoLabel.text = str(ammo)
	
	
func _physics_process(delta):
	behavior.duration += delta 
	time_notUsingStamina +=delta
	time_notAttack +=delta
	
	#invinciblityのisプロパティがtrueのとき、durationプロパティのカウントを進める。
	if invinciblity.is :
		var inv = invinciblity
		inv.duration += delta
		#durationがperiodを超えたとき、無敵を解除する。
		if inv.duration > inv.period:
			inv.is = false
			inv.duration= 0
			inv.period = 0
	
	if is_reloading :
		reloadProgress +=delta
		if reloadProgress >= reloadSpan:
			bLog.addLog("リロード完了")
			ammo = magazineAmmo
			ammoLabel.text = str(ammo)
			is_reloading = false
			reloadProgress =0
			
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
		
	if Input.is_action_pressed("attack"):
		attack()
		
	
	if Input.is_action_just_pressed("reload") :
		if ammo >= magazineAmmo:
			print("マガジンはフルだ")
		else:
			startReload()
		
		
	
	# Add the gravity.
	
	if not is_on_floor():
		$AnimatedSprite2D.animation = "jump"
		velocity.y += gravity * delta
	else:
		air_jump = max_air_jump
		$AnimatedSprite2D.animation = "idle"
		switch_behavior("idle")

	# Handle Jump.
	if Input.is_action_just_pressed("jump"):
		if Input.is_action_pressed("move_down"):
			position += Vector2(0,10)
		else:
			if is_on_floor():
				switch_behavior("jump")
				velocity.y = JUMP_VELOCITY
			elif air_jump > 0:
				air_jump -= 1
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
	if direction != 0  :
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	
func _on_area_2d_body_entered(body):
	if body.TYPE != null and body.TYPE =="enemy":
		print("敵にぶつかった")
		decreaseHp()
		
#dashing:ダッシュに関連するメソッド。
func dashing(delta):
	
	#"is_dashing"がtrueでないときに、ダッシュに割り当てられたボタンが押されたなら、
	#"is_dashing"がtrueになり、スピードがdash_rateだけ乗算される。
	if Input.is_action_just_pressed("dash") and direction !=0 and stamina > 0 and not is_dashing.is :
		speed *= dash_rate
		if stamina< 2:
			stamina = 0
		else:
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
			if time_notAttack>attackSpan.melee:
				var atk =weapon_melee.instantiate()
				if looking_at > 0:
					atk.rotate_reverse = true
				atk.atk =attackPower.melee
				add_child(atk)
				time_notAttack=0
			
		"gun":
			if time_notAttack>attackSpan.gun:
				if is_reloading:
					print("リロード中は撃てない")
				else:
					var gun =$"gun_weapon"
					if ammo >0:
						ammo -=1
						ammoLabel.text = str(ammo)
						var atk =bullet.instantiate()
						atk.position = gun.position
						atk.atk =attackPower.gun
						add_child(atk)
						time_notAttack=0
						if ammo == 0:
							print("弾切れ。リロードします")
							startReload()
					else:
						print("弾切れです")
			
func invincible(period):
	invinciblity.is = true
	invinciblity.period = period
	
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
		remove_child($"gun_weapon")
	
func startReload():
	bLog.addLog("リロード中")
	is_reloading = true
	
	
func decreaseHp(v=1):
	if invinciblity.is:
		v = 0
	else:
		bLog.addLog(str(v)+"のダメージを受けた")
	hp -= v
	bLog.addLog(str(v)+"のダメージを 受けた")
	dmgD.showDmg(v,"player",position)
	if hp <= 0:
		dead("YOU ARE DEAD")
		
func dead(will:String = ""):
	bLog.addLog("死んだ")
	var bld = bld_exp.instantiate()
	bld.position = position
	add_sibling(bld)
	var fd = $"../UI/FullScreenDisplay"
	fd.showString(will)
	queue_free()
	

