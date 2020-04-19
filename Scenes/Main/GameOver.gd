extends Control

onready var levels = get_tree().get_root().get_node("Main/Levels")

func _ready():
	pass

func animation():
	$AnimationPlayer.play("gui")


func _on_Button_pressed():
	var items = load("res://Data/Items.gd")
	Items.replace_by(items.new())
	var localplayer = load("res://Data/LocalPlayer.gd")
	
	LocalPlayer.replace_by(localplayer.new())
	
	get_tree().reload_current_scene()


func _on_Button2_pressed():
	get_tree().quit()
