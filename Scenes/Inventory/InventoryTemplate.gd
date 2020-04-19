extends GridContainer

onready var ItemSlotScene = preload("ItemSlot.tscn")

var inventory_ids = []
export var size = 3
export var inventory_name = "player_hotbar"

func _ready():
	
	for slot in range(size):
		var new_item_slot = ItemSlotScene.instance()
		new_item_slot.slotId = slot
		add_child(new_item_slot)


func set_item( slotId:int, itemId:int, count:int = 1 ):
	if slotId < size:
		get_child(slotId).itemId=itemId
		get_child(slotId).count=count

func register():
	Items.register_inventory(self,inventory_name)
