extends Spatial

var activate = []
var open = false
export var openId = 10

func _ready():
	var a =0
	for child in get_children():
		if (child is StaticEnemy):
			child.connect("active",self,"on_activate",[a])
			activate.append(false)
			a+=1
	for child in get_child(0).get_children():
		if (child is InventoryObject):
			child.connect("active",self,"on_activate",[a])
			activate.append(false)
			a+=1
			
func on_activate(val):
	if not(open):
		activate[val] = true
		var count = true
		for acti in activate:
			count = count and acti
		if count:
			open = true
			$AnimationPlayer.play("open")
