extends Area

func _ready():
	for child in get_children():
			child.visible = false


func _on_LightController_body_entered(body):
	var player = get_node(LocalPlayer.Player)
	if body.name == "Player":
		for child in get_children():
			child.visible = true


func _on_LightController_body_exited(body):
	var player = get_node(LocalPlayer.Player)
	if body.name == "Player":
		for child in get_children():
			child.visible = false
