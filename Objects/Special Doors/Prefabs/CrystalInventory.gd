extends InventoryObject

onready var template = preload("res://Scenes/Inventory/Template.tscn")
export var crystalId = -1
var inventory
var inventory_name = ""

signal active

func _ready():
	crystalId = get_parent().get_parent().openId
	inventory = template.instance()
	inventory.label = "Crystal Door"
	inventory_id = LocalPlayer.custom_inventory_count 
	LocalPlayer.custom_inventory_count +=1
	inventory.get_node("CenterContainer/Inventory").inventory_name = "crystal"+str(inventory_id*crystalId)
	inventory_name =  "crystal"+str(inventory_id*crystalId)
	inventory.get_node("CenterContainer/Inventory").register()
	get_node(LocalPlayer.customInventory).add_child(inventory)
	print("inv num",inventory_name)
	inventory.get_child(0).get_child(0).get_child(0).connect("item_changed",self,"on_change")
	
func on_change():
	print(inventory.get_child(0).get_child(0).get_child(0).itemId)
	if inventory.get_child(0).get_child(0).get_child(0).itemId == crystalId:
		print("open")
		emit_signal("active")
