extends StaticEnemy

signal active

func _ready():
	pass

func damage(amount):
	emit_signal("active")
