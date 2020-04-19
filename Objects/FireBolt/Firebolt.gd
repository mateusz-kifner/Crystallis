extends KinematicBody

export var direction = Vector3(1,0,0)
export var speed = 0.1

func _physics_process(delta):
	var colls = move_and_collide(direction.normalized()*speed)
	if colls:

		if colls is KinematicCollision:
			var coll = colls.collider
			if (coll is Enemy)  or (coll is StaticEnemy):
				coll.damage(20)
			queue_free()
