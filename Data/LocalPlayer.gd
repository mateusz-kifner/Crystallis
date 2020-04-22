extends Node

export var guiInventory:NodePath
export var gui:NodePath
export var Level:NodePath
export var inventoryName = ""
export var Cursor:NodePath
export var Player:NodePath
export var navmesh:NodePath

export var player_health = 100 setget set_health
export var player_mana = 100 setget set_mana


export var ACTION_OPEN_INVENTORY = "open_inventory"
export var ACTION_CLOSE_INVENTORY = "close_inventory"

var cursor_state = [true,false,false]
var cursor_colors = ["#ffffff","#f7f634","#ff0000"]

export var level = -1
export var inventory_open = false

export var levels = {
	2:"res://Scenes/Level1/Level1.tscn",
	1:"res://Scenes/Level2/Level2.tscn"
}
var pause_count = 0
export var custom_inventory_count =1
export var customInventory:NodePath

enum CURSOR {
	NORMAL = 0
	INTERACTIVE = 1,
	ENEMY = 2
}

func set_level(id:int):
	if id != -1:
		get_node(gui).get_node("Stats").visible = true
		get_node(Cursor).visible = true
		for child in get_tree().get_root().get_node("Main/Levels").get_children():
			child.queue_free()
		level = id
		var level = load(levels[id])
		get_tree().get_root().get_node("Main/Levels").add_child(level.instance())
	else:
		get_node(gui).get_node("MainMenu").show()
		get_node(gui).get_node("Stats").visible = false
		get_node(Cursor).visible = false
		for child in get_tree().get_root().get_node("Main/Levels").get_children():
			child.queue_free()
func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS

func openInventory(name:String):
	if inventoryName == "":
		inventoryName = name
		inventory_open = true
		var inv = Items.inventory_instances.values()
		for i in range(2,inv.size()):
			inv[i].get_parent().visible = false
			inv[i].get_parent().rect_position = Vector2(-5000,0)
		Items.inventory_instances[name].get_parent().visible = true
		Items.inventory_instances[name].get_parent().rect_position = Vector2(0,0)
		get_node(guiInventory).visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		pause(true)
	else:
		inventory_open = false
		inventoryName = ""
		get_node(guiInventory).visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		pause(false)

func addToInventory(id:int,count:int):
	Items.inventory_instances[0].add_item(id,count)

func changeCursor(cursor:int,state):
	cursor_state[cursor] = state
	var cursor_color = "#ffffff"
	for i in range(cursor_state.size()):
		if cursor_state[i]:
			cursor_color = cursor_colors[i]
	get_node(Cursor).modulate = Color(cursor_color)
	

func _process(delta):
	if(Input.is_action_just_pressed(ACTION_OPEN_INVENTORY)):
		LocalPlayer.openInventory("player_hotbar")
	if(inventory_open and Input.is_action_just_pressed(ACTION_CLOSE_INVENTORY)):
		LocalPlayer.openInventory("player_hotbar")

func set_health(val):
	if val >100:
		player_health = 100
	elif val <=0:
		player_health = 0
		get_node(gui).get_node("GameOver").visible = true
		get_node(gui).get_node("GameOver").animation()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		pause(true)
	else:
		player_health = val
		
		
	get_node(gui).get_node("Stats/health").text = str(player_health) + "HP"
	
func set_mana(val):
	if val <100:
		player_mana = val
	else:
		player_mana = 100
		
#	get_node(gui).get_node("Stats/health").text = str(player_mana) + "HP"
	

func pause(pause):
	print(pause_count)
	if pause:
		pause_count +=1
	else:
		pause_count -=1
	if(pause_count >0):
		get_tree().paused = true
	else:
		get_tree().paused = false
		
