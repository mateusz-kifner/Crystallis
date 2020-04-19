extends Area

var player

func _ready():
	yield(get_tree(),"idle_frame")
	player = get_node(LocalPlayer.Player)	


func _on_DeathArea_body_entered(body):
	if body.name == "Player":
		get_node(LocalPlayer.Player).damage(10000)
