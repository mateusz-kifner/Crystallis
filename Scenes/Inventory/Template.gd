extends Control

export var label = "" setget set_label
export var inventory:NodePath

func _ready():
	inventory = get_path()

func set_label(val):
	label = val
	$CenterContainer/Control/Label.text = val
