extends Control

onready var levels = get_tree().get_root().get_node("Main/Levels")

func _ready():
	pass

func _physics_process(delta):
	if LocalPlayer.inventoryName == "" :
		yield(get_tree(),"idle_frame")
		if Input.is_action_just_pressed("open_menu") and levels.get_child_count() > 0:
			visible = not(visible)
			if(visible):
				LocalPlayer.pause(true)
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			else:
				LocalPlayer.pause(false)
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		


func _on_Button_pressed():
	var items = load("res://Data/Items.gd")
	Items.replace_by(items.new())
	var localplayer = load("res://Data/LocalPlayer.gd")
	
	LocalPlayer.replace_by(localplayer.new())
	
	get_tree().reload_current_scene()


func _on_Button2_pressed():
	get_tree().quit()
