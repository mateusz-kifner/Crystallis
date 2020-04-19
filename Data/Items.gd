extends Node

export var path_to_item_icons = "res://Images/Items/"
var drag_preview_id = -1
var drag_data = []
var inventory_instances = {}
var info_box_instance:NodePath

export(PoolColorArray) var colors = [
	Color(0x550011ff),
	Color(0x110055ff),
	Color(0x005511ff),
	Color(0x444400ff),
	Color(0x999999ff)
]

export(Dictionary) var data = {
	0:{
		"label":"NOT USED",
		"description":"Beautiful blue gem, it'll make you rich.",
		"icon":"Potion1_64.png",
		"show_count":true,
		"count":1,
		"max_stack":100,
		"color":1,
		"obj_path":"res://Objects/Potion/1/Potion1.tscn",
	},
	1:{
		"label":"Big heal",
		"description":"Restores 50HP",
		"icon":"Potion1_64.png",
		"show_count":true,
		"effect":"heal",
		"effect_amount":50,
		"count":1,
		"max_stack":1,
		"color":0,
		"obj_path":"res://Objects/Potion/1/Potion1.tscn",
	},
	2:{
		"label":"Small heal",
		"description":"Restores 20HP",
		"icon":"Potion2_64.png",
		"show_count":true,
		"effect":"heal",
		"effect_amount":20,
		"count":1,
		"max_stack":1,
		"color":0,
		"obj_path":"res://Objects/Potion/2/Potion2.tscn",
	},
	3:{
		"label":"Big mana",
		"description":"Restores 50MP",
		"icon":"Potion4_64.png",
		"show_count":true,
		"effect":"mana",
		"effect_amount":50,
		"count":1,
		"max_stack":1,
		"color":1,
		"obj_path":"res://Objects/Potion/3/Potion3.tscn",
	},
	4:{
		"label":"Small Mana",
		"description":"Restores 20MP",
		"icon":"Potion3_64.png",
		"show_count":true,
		"effect":"mana",
		"effect_amount":20,
		"count":1,
		"max_stack":1,
		"color":1,
		"obj_path":"res://Objects/Potion/4/Potion4.tscn",
	},
	5:{
		"label":"Sword",
		"description":"Sharp object, don't cut yourself.",
		"icon":"Potion3_64.png",
		"show_count":false,
		"count":1,
		"max_stack":1,
		"color":3,
		"obj_path":"res://Objects/Sword/1/Sword.tscn",
	},
	6:{
		"label":"Blue Crystal",
		"description":"Sharp object, don't cut yourself.",
		"icon":"Crystal_blue_64.png",
		"show_count":false,
		"count":1,
		"max_stack":1,
		"color":4,
		"obj_path":"res://Objects/Crystal/Crystal blue.tscn",
	},
	7:{
		"label":"Blue Crystal",
		"description":"Sharp object, don't cut yourself.",
		"icon":"Crystal_blue_64.png",
		"show_count":false,
		"count":1,
		"max_stack":1,
		"color":4,
		"obj_path":"res://Objects/Crystal/Crystal blue.tscn",
	},
	8:{
		"label":"Green Crystal",
		"description":"Sharp object, don't cut yourself.",
		"icon":"Crystal_green_64.png",
		"show_count":false,
		"count":1,
		"max_stack":1,
		"color":4,
		"obj_path":"res://Objects/Crystal/Crystal green.tscn",
	},
	9:{
		"label":"Red Crystal",
		"description":"Sharp object, don't cut yourself.",
		"icon":"Crystal_red_64.png",
		"show_count":false,
		"count":1,
		"max_stack":1,
		"color":4,
		"obj_path":"res://Objects/Crystal/Crystal red.tscn",
	},
	10:{
		"label":"Blue Crystal",
		"description":"Sharp object, don't cut yourself.",
		"icon":"Crystal_blue_64.png",
		"show_count":false,
		"count":1,
		"max_stack":1,
		"color":4,
		"obj_path":"res://Objects/Crystal/Crystal blue.tscn",
	},
} setget _set_data

export var count = -1

func _ready():
	count = data.size()
	
func _set_data(val):
	count = val.size()
	data = val

func register_inventory(node,name):
	inventory_instances[name] = node
	
	
	
func set_infobox(itemId,slotId,inventory):
	var info_box = get_node(info_box_instance)
	if not(info_box.itemId == itemId and itemId >0):
		info_box.itemId = itemId
		info_box.description = data[itemId]["description"]
		info_box.itemLabel = data[itemId]["label"]
		info_box.set_sprite(data[itemId]["icon"])
	




