extends Node

var ene = preload ("res://enemy.tscn")
var counter = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass


func _on_timer_timeout():
	var eneInstance =ene.instantiate()
	counter +=1
	eneInstance.name ="enemy"+str(counter)
	add_child(eneInstance)
	pass # Replace with function body.


func _on_player_tree_exited():
	$"Timer".stop()
	pass # Replace with function body.


func _on_button_button_up():
	$"Timer".start()
	pass # Replace with function body.
