extends GridContainer

onready var ItemSlotScene = preload("ItemSlot.tscn")


var inventory_ids = []
var size = 12
export var inventory_name = "player_backpack"

func _ready():
	Items.register_inventory(self,"player_backpack")
	for slot in range(size):
		var new_item_slot = ItemSlotScene.instance()
		new_item_slot.slotId = slot
		add_child(new_item_slot)
	get_child(0).itemId = -1
	get_child(1).itemId = 10
	get_child(2).itemId = 10
	get_child(3).itemId = 10
	get_child(4).itemId = 9
	get_child(5).itemId = 9
	get_child(6).itemId = 9
	get_child(7).itemId = 8
	get_child(8).itemId = 8
	get_child(9).itemId = 8
	
	


func set_item( slotId:int, itemId:int, count:int = 1 ):
	if slotId < size:
		get_child(slotId).itemId=itemId
		get_child(slotId).count=count

func add_item(itemId:int,count:int=1):
	var item_set = false
	for child in get_children():
		if(child.itemId == itemId and item_set ==false):
			item_set = true
			child.count += count
	for child in get_children():
		if(child.itemId == -1 and item_set ==false):
			item_set = true
			child.itemId = itemId
			child.count = count
			
			
			
			
			
			
			
