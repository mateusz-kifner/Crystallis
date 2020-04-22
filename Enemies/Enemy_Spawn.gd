extends Position3D

export var enemy_id = 1

var enemies = {
	1:"res://Enemies/Skieleton/Skieleton.tscn",
	2:"res://Enemies/Slime/Slime.tscn",
}

func _ready():
	var new_enemy = load(enemies[enemy_id])
	add_child(new_enemy.instance())
