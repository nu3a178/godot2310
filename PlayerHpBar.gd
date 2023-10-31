extends ProgressBar

var plr 
var maxhp
var hp
# Called when the node enters the scene tree for the first time.
func _ready():
	plr = $"../../Player"
	hp = plr.hp
	maxhp = hp
	print(str(hp)+"/"+str(maxhp))
	max_value = maxhp



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if plr !=null:
		hp = plr.hp
	else:
		hp = 0
	value = hp
	$"Label".text = str(hp)+"/"+str(maxhp)
		
	
