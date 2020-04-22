extends Enemy

var path = []
var path_ind = 0
export var MOVE_SPEED = 5
const FLOOR_NORMAL_VECTOR = Vector3(0,1,0)
onready var nav

export var health = 25
export var damage = 10

var player
onready var skieleton = $Armature
onready var MODEL = $Armature/Skeleton/Cube
var angle = 0
var attack
var dead = false
var is_damaged = false
const DAMAGE = 15

var follow = false
var is_following = false
var attack_dealy = false

func _ready():
	add_to_group("units")
	yield(get_tree(),"idle_frame")
	nav = get_node(LocalPlayer.navmesh)
	player = get_node(LocalPlayer.Player)
	$AnimationPlayer.play("idle")

func _physics_process(delta):
	var bodies =$Armature/Skeleton/Cube/DamageArea.get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player" and not(attack_dealy) and not(dead):
			get_node(LocalPlayer.Player).damage(10)
			$AttackDealy.start(0.7)
			attack_dealy = true
	if not (dead) and not (is_damaged):
		if follow and not(is_following):
			$Follow.start(0.5)
			is_following = true
	
		if path_ind < path.size():
			if $AnimationPlayer.current_animation != "walk":
				$AnimationPlayer.play("walk",-1,1.5)
			var move_vec = (path[path_ind] - global_transform.origin)
			if move_vec.length() < 0.1:
				path_ind += 1
			else:
				var new_angle = (-Vector2(-1,0).angle_to(Vector2(move_vec.x,move_vec.z))) + (PI/2.0)+PI
				skieleton.rotation = Vector3(0,new_angle,0)
				move_and_slide(move_vec.normalized() * MOVE_SPEED, FLOOR_NORMAL_VECTOR)
		else:
			$AnimationPlayer.play("idle")
				
func move_to(target_pos):
	path = nav.get_simple_path(global_transform.origin, target_pos)
	path_ind = 0

#func walk(delta):
#	# RESET
#	var direction = Vector3()
#	var aim = $Head/Camera.get_global_transform().basis
#
#	# Arrows
#	if Input.is_action_pressed(ACTION_FORWARD):
#		direction += -aim.z
#	if Input.is_action_pressed(ACTION_BACKWARD):
#		direction += aim.z
#	if Input.is_action_pressed(ACTION_LEFT):
#		direction += -aim.x
#	if Input.is_action_pressed(ACTION_RIGHT):
#		direction += aim.x
#	direction.y = 0
#	direction = direction.normalized()
#
#	velocity.y -= GRAVITY * delta
#
#	if is_on_floor():
#		has_contact = true
#
#		var floor_angle = rad2deg(acos($FloorDetector.get_collision_normal().dot(FLOOR_NORMAL_VECTOR)))
#		if floor_angle > SLOPE_SLIDE_ANGLE:
#			velocity.y -= GRAVITY * delta
#
#	else:
#		if not($FloorDetector.is_colliding()):
#			has_contact = false
#
#		velocity.y -= GRAVITY * delta
#
#	if has_contact and not(is_on_floor()):
#		move_and_collide(Vector3(0,-0.1,0))
#
#
#	#Sprint
#	var speed = 0
#	if Input.is_action_pressed("sprint"):
#		speed = RUN_SPEED_MAX
#	else:
#		speed = WALK_SPEED_MAX
#
#
#	# prevent flying
#	var temp_velocity = velocity
#	temp_velocity.y = 0
#
#	# walk accel
#	var accel = 0
#	if direction.dot(temp_velocity) > 0:
#		accel = WALK_ACCEL
#	else:
#		accel = WALK_DECEL
#
#	# limit speed
#	temp_velocity = temp_velocity.linear_interpolate(direction*speed, accel*delta)
#
#	if has_contact and Input.is_action_just_pressed(ACTION_JUMP):
#		velocity.y = JUMP_HEIGHT
#
#	velocity.x = temp_velocity.x
#	velocity.z = temp_velocity.z
#
#	# move_and_slide Vector3(0,0,0) bug workaround
##	if (velocity.length() >0.1):
#	velocity = move_and_slide(velocity,FLOOR_NORMAL_VECTOR)
#


func _on_Area_body_entered(body):
	if body.name == "Player":
		attack = true


func _on_Area_body_exited(body):
	if body.name == "Player":
		attack = false

func _on_Damage_timeout():
	MODEL.material_override = null
	if is_damaged :
		is_damaged = false
	if dead:
		queue_free()
	if attack :
		player.damage(DAMAGE)

func damage(amount:int):
	MODEL.material_override = load("res://Materials/Bones_Red.material")
	
	if health -amount > 0:
		health -= amount
		is_damaged = true
		$Damage.start(0.5)
		$AnimationPlayer.play("damage")
	else:
		dead = true
		$Damage.start(1)
		$AnimationPlayer.play("damage")




func _on_PlayerDetector_body_entered(body):
	if body.name == "Player":
		follow = true


func _on_PlayerDetector_body_exited(body):
	if body.name == "Player":
		follow = false


func _on_Follow_timeout():
	move_to(player.global_transform.origin - Vector3(0,1,0))
	is_following = false


func _on_DamageArea_body_entered(body):
	pass


func _on_AttackDealy_timeout():
	attack_dealy = false
