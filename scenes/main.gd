extends Node

@onready var player = $Player
@onready var camera = $Camera2D
var count = 1
var enemyCount = 0
var level = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player != null:
		camera.global_position = player.global_position+ Vector2(0,-200)
		
	

func spawnEnemy(n = 1):
		var path = $EnemySpawnPath/Follow

		
		for i in range(n):
			var ene = preload("res://scenes/enemy.tscn").instantiate()
			ene.name = "enemy"+str(i)
			path.progress_ratio = randf()
			while abs(path.position.x - $Player.position.x) <400 : 
				path.progress_ratio = randf()
			ene.position = path.position
			add_child(ene)
			enemyCount +=1
		$UI/EnemyCount.text = "残り"+str(enemyCount)+"体"

func decreaseEnemyCount():
	enemyCount -=1
	$UI/EnemyCount.text = "残り"+str(enemyCount)+"体"
	if enemyCount <=0:
		nextLevel()
		
func nextLevel(v=1):
	level+=v

func _on_button_button_up():
	$UI/BattleLog.addLog("GAME START")
	$UI/Button.queue_free()
	spawnEnemy(5)
	pass # Replace with function body.
