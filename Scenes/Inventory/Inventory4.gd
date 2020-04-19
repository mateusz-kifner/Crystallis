extends GridContainer

onready var ItemSlotScene = preload("ItemSlot.tscn")

var inventory_ids = []
var size = 1
export var inventory_name = "player_drop"

func _ready():
	Items.register_inventory(self,"player_drop")
	for slot in range(size):
		var new_item_slot = ItemSlotScene.instance()
		new_item_slot.slotId = slot
		add_child(new_item_slot)
	get_child(0).connect("item_changed",self,"drop")


func set_item( slotId:int, itemId:int, count:int = 1 ):
	if slotId < size:
		get_child(slotId).itemId=itemId
		get_child(slotId).count=count

func drop():
	var player = get_node(LocalPlayer.Player)
	var item = get_child(0)
	if(item.itemId != -1):
		yield(get_tree(), "idle_frame")
		var obj = load(item.obj_path)
		var position = player.get_node("Head/Camera/DropPosition").global_transform.origin
		print(item.count)
		for i in range(item.count):
			var new_obj = obj.instance()
			player.get_parent().add_child(new_obj)
			new_obj.global_transform.origin = position
		set_item(0,-1,-1)
	else:
		yield(get_tree(), "idle_frame")
		get_child(0).count=-1
