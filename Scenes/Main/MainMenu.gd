extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func show():
	visible = true
	$Timer.stop()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$CenterContainer/Control.visible = true
	$CenterContainer/Loading.visible =false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	$CenterContainer/Control.visible = false
	$CenterContainer/Loading.visible =true
	$Timer.start(3)
	yield(get_tree(),"idle_frame")
	yield(get_tree(),"idle_frame")
	LocalPlayer.set_level(1)


func _on_Timer_timeout():
	visible = false


func _on_Button3_pressed():
	get_tree().quit()


func _on_Button2_pressed():
	$CenterContainer/Control.visible = false
	$CenterContainer/Credits.visible = true


func _on_Button4_pressed():
	$CenterContainer/Control.visible = true
	$CenterContainer/Credits.visible = false
