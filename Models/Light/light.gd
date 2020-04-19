extends Spatial


func _ready():
	randomize()
	var r = randf()*5
	$AnimationPlayer.play("light")
	$AnimationPlayer.advance(r)
