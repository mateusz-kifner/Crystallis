extends KinematicBody

onready var firebolt = preload("res://Objects/FireBolt/Firebolt.tscn")

export var ACTION_FORWARD = "forward"
export var ACTION_BACKWARD = "backward"
export var ACTION_LEFT = "left"
export var ACTION_RIGHT = "right"
export var ACTION_SPRINT = "sprint"
export var ACTION_JUMP = "jump"
export var ACTION_INTERACT = "interact"
export var MOUSE_SENSITIVITY = 0.3

const FLOOR_NORMAL_VECTOR = Vector3(0,1,0)
const GRAVITY = 9.8 * 4
const WALK_SPEED_MAX = 10
const RUN_SPEED_MAX = 20
const WALK_ACCEL = 8
const WALK_DECEL = 16
const WALK_SPEED = 100
const JUMP_HEIGHT = 16
const SLOPE_SLIDE_ANGLE = 60

const FLY_SPEED = 40
const FLY_ACCEL = 4

var camera_angle = 0
var camera_change = 0

var velocity = Vector3()

var has_contact = false

var sword_slot_id =  -1
var gem_slot_id = -1
var is_attacking = false
var attack_delay = false

var is_fly = false
var aim

var magic_delay = false

func _ready():
	LocalPlayer.Player = self.get_path()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	


func _physics_process(delta):
	if not(is_attacking) and $AnimationPlayer2.current_animation != "idle":
		$AnimationPlayer2.play("idle")
		
	equip_weapons()
	if is_fly:
		fly(delta)
	else:
		walk(delta)
	interact()
	if Input.is_action_just_pressed("use_heal"):
		use_item(1)
	if Input.is_action_just_pressed("use_mana"):
		use_item(2)
	if OS.is_debug_build() and Input.is_action_just_pressed("quit"):
		LocalPlayer.set_level(2)
	if OS.is_debug_build() and Input.is_action_just_pressed("debug_fly"):
		is_fly = not(is_fly)

func walk(delta):
	# RESET
	var direction = Vector3()
	var aim = $Head/Camera.get_global_transform().basis
	
	# Arrows
	if Input.is_action_pressed(ACTION_FORWARD):
		direction += -aim.z
	if Input.is_action_pressed(ACTION_BACKWARD):
		direction += aim.z
	if Input.is_action_pressed(ACTION_LEFT):
		direction += -aim.x
	if Input.is_action_pressed(ACTION_RIGHT):
		direction += aim.x
	direction.y = 0
	direction = direction.normalized()
	
	velocity.y -= GRAVITY * delta
	
	if is_on_floor():
		has_contact = true

		var floor_angle = rad2deg(acos($FloorDetector.get_collision_normal().dot(FLOOR_NORMAL_VECTOR)))
		if floor_angle > SLOPE_SLIDE_ANGLE:
			velocity.y -= GRAVITY * delta

	else:
		if not($FloorDetector.is_colliding()):
			has_contact = false

		velocity.y -= GRAVITY * delta

	if has_contact and not(is_on_floor()):
		move_and_collide(Vector3(0,-0.1,0))

	
	#Sprint
	var speed = 0
	if Input.is_action_pressed("sprint"):
		speed = RUN_SPEED_MAX
	else:
		speed = WALK_SPEED_MAX
	

	# prevent flying
	var temp_velocity = velocity
	temp_velocity.y = 0
	
	# walk accel
	var accel = 0
	if direction.dot(temp_velocity) > 0:
		accel = WALK_ACCEL
	else:
		accel = WALK_DECEL
	
	# limit speed
	temp_velocity = temp_velocity.linear_interpolate(direction*speed, accel*delta)

	if has_contact and Input.is_action_just_pressed(ACTION_JUMP):
		velocity.y = JUMP_HEIGHT
	
	velocity.x = temp_velocity.x
	velocity.z = temp_velocity.z
	
	# move_and_slide Vector3(0,0,0) bug workaround
#	if (velocity.length() >0.1):
	velocity = move_and_slide(velocity,FLOOR_NORMAL_VECTOR)
	
func fly(delta):
	var direction = Vector3()
	
	var aim = $Head/Camera.get_global_transform().basis
	
	if Input.is_action_pressed(ACTION_FORWARD):
		direction += -aim.z
	if Input.is_action_pressed(ACTION_BACKWARD):
		direction += aim.z
	if Input.is_action_pressed(ACTION_LEFT):
		direction += -aim.x
	if Input.is_action_pressed(ACTION_RIGHT):
		direction += aim.x
	velocity = velocity.linear_interpolate(direction.normalized()*FLY_SPEED, FLY_ACCEL*delta)
	move_and_slide(velocity,FLOOR_NORMAL_VECTOR)

func interact():
	var collider = $Head/Camera/InteractionDetector.get_collider()
	if collider is InteractiveObject:
		LocalPlayer.changeCursor(LocalPlayer.CURSOR.INTERACTIVE,true)
	else:
		LocalPlayer.changeCursor(LocalPlayer.CURSOR.INTERACTIVE,false)
	if collider is Enemy:
		LocalPlayer.changeCursor(LocalPlayer.CURSOR.ENEMY,true)
	else:
		LocalPlayer.changeCursor(LocalPlayer.CURSOR.ENEMY,false)
		
	if(Input.is_action_just_pressed(ACTION_INTERACT)):

		if collider is InteractiveObject:
			if collider is InventoryObject and LocalPlayer.inventoryName == "":
				LocalPlayer.openInventory(collider.inventory_name)
			else:
				Items.inventory_instances["player_backpack"].add_item(collider.itemId,collider.count)
				collider.apply_central_impulse((translation - collider.translation).normalized() * 50)
				collider.get_node("Timer").start(0.2)

func equip_weapons():
	var hotbar =  Items.inventory_instances["player_hotbar"]
	if hotbar.get_child(0).itemId != sword_slot_id:
		sword_slot_id = hotbar.get_child(0).itemId
		if(sword_slot_id != -1):
			yield(get_tree(), "idle_frame")
			var obj = load(hotbar.get_child(0).obj_path)
			var new_obj = obj.instance()
			$Head/Camera/Weapon.add_child(new_obj)
		else:
			$Head/Camera/Weapon.get_child(0).queue_free()

func use_item(id):
	var item = Items.inventory_instances["player_hotbar"].get_child(id)
	if item.itemId != -1:
		if Items.data[item.itemId].effect:
			if Items.data[item.itemId].effect == "heal":
				LocalPlayer.player_health += Items.data[item.itemId].effect_amount
		if item.count >1:
			item.count -=1
		else:
			item.itemId = -1

func _input(event):
	if event is InputEventMouseMotion:
		camera_change = event.relative
		if camera_change.length() > 0 :
			$Head.rotate_y(-deg2rad(camera_change.x*MOUSE_SENSITIVITY))
			var change = camera_change.y*MOUSE_SENSITIVITY
			if change + camera_angle >-89 and change + camera_angle < 89:
				$Head/Camera.rotate_x(-deg2rad(change))
				camera_angle += change
		camera_change = Vector2()
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			attack()
		if event.button_index == BUTTON_RIGHT and event.pressed:
			magic()
			
			
func damage(amount:int):
	LocalPlayer.player_health -= amount
	$AnimationPlayer.play("damage")


func attack():
	if not(is_attacking) and not(attack_delay):
		is_attacking = true
		$AnimationPlayer2.play("attack")
		$Attack.start(0.3)

func magic():
	if not(magic_delay):
		var magic = $Head/Camera/Magic.global_transform
		var new_firebolt = firebolt.instance()
		get_tree().get_root().get_node("Main/Levels").add_child(new_firebolt)
		new_firebolt.direction = -$Head/Camera/Magic.global_transform.origin + $Head/Camera/Magic/Position3D.global_transform.origin
		new_firebolt.global_transform= magic
		magic_delay = true
		$Magic.start(1)

func _on_Attack_timeout():
	if is_attacking:
		is_attacking = false
		attack_delay = true
		$Attack.start(0.6)
		var weaponarea = $Head/WeaponHit
		var colls = weaponarea.get_overlapping_bodies()
		print(colls)
		for coll in colls:
			if (coll is Enemy) or (coll is StaticEnemy):
				coll.damage(20)
	else:
		attack_delay = false


func _on_Magic_timeout():
	magic_delay = false
