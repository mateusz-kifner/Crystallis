extends PanelContainer

export(int) var slotId = -1 
export(int) var itemId = -1 setget set_itemId
var label = "" setget set_label
var sprite_path:String = "" setget set_sprite
var count:int = -1 setget set_count
var description:String = ""
var sprite:Texture
var color:Color = Color(0x242426ff) setget set_color
var can_drag = true
export var obj_path:String ="" setget set_obj_path

onready var stylebox = preload("ItemSlot.stylebox")

signal item_changed

# TODO:
# PLACE one
# DIVIDE half
# place evenly

func init(val=itemId):

	if(itemId >=0):
		sprite = load(Items.path_to_item_icons + Items.data[itemId].icon)
		set_sprite(sprite)
		set_label(Items.data[itemId].label)
		set_count(Items.data[itemId].count)
		set_color(Items.colors[Items.data[itemId].color])
		set_obj_path(Items.data[itemId].obj_path)
		print(obj_path)
	else:
		set_sprite(null)
		set_label("")
		set_count(-1)
		set_color(Color(0x242426ff))
		sprite = null
		obj_path = ""

func set_sprite(val):
	$VBoxContainer/CenterContainer/Sprite.set_texture(val)
	
func set_label(val):
	$VBoxContainer/Label.text = val
	
func set_count(val):
	if val>0:
		$Control/Count.text = 'x'+str(val)
		count = val
	else:
		$Control/Count.text = ''
		count = val

func set_color(val):
	color = val
	var new_stylebox = stylebox.duplicate()
	new_stylebox.bg_color = val
	set("custom_styles/panel",new_stylebox)

func set_itemId(val):
	itemId = val
	init(val)
	emit_signal("item_changed")

func set_obj_path(val):
	obj_path = val

func custom_get_drag_data(pos):
	var drag_preview = TextureRect.new()
	drag_preview.set_texture(sprite)
	drag_preview.rect_size = Vector2(50, 50)
	CursorRenderer.render_cursor(sprite,count)
	return [itemId,self,Input.is_action_pressed("shift"),get_parent().inventory_name]


func custom_can_drop_data(data):
#	print("can_drop", data)
	var drop_itemId = data[0]
	#Does drop_itemid exist and within range
	var check = drop_itemId>=0 and drop_itemId < Items.count
	#Can drop occure
	check = check and itemId == -1 or itemId == drop_itemId
	#Don't drop on self
	check = check and( (data[3] == get_parent().inventory_name and data[1].slotId != slotId) or data[3] != get_parent().inventory_name)
	return check


func custom_drop_data(data,drop_count=-1):
	var drop_itemId = data[0]
	if(data[2] and data[1].count >0):
		if itemId == drop_itemId:
			set_count(count+1)
			if(data[1].count-1 ==0):
				data[1].set_itemId(-1)
			else:
				data[1].set_count(data[1].count-1)
		else:
			set_itemId(drop_itemId)
			set_count(1)
			if(data[1].count-1 == 0):
				data[1].set_itemId(-1)
			else:
				data[1].set_count(data[1].count-1)
	else:
		if itemId == drop_itemId:
			set_count(count+data[1].count)
		else:
			set_itemId(drop_itemId)
			set_count(data[1].count)
		data[1].set_itemId(-1)

func _input(event):
	if event is InputEventMouseMotion:
		if itemId != -1 and Rect2(rect_global_position,rect_size).has_point(event.position):
			Items.set_infobox(itemId,slotId,get_parent().inventory_name)
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if Items.drag_data.size() < 1 :
				if itemId != -1:
					if Rect2(rect_global_position,rect_size).has_point(event.position):
						Items.drag_data = custom_get_drag_data(event.position)
			else:
				if Rect2(rect_global_position,rect_size).has_point(event.position):
					if custom_can_drop_data(Items.drag_data):
						custom_drop_data(Items.drag_data)
					Items.drag_data.clear()
					CursorRenderer.render_cursor(null,-1)
		elif event.button_index == BUTTON_LEFT and not(event.pressed):
			pass
		# elif event.button_index == BUTTON_RIGHT and event.pressed:
		# 	print("right pressed")



#func _input(event):
#	if event is InputEventMouseButton:
#		if event.button_index == BUTTON_RIGHT and event.pressed:
#			var drag_preview = TextureRect.new()
#			drag_preview.set_texture(sprite)
#			drag_preview.rect_size = Vector2(50, 50)
#			force_drag([itemId,self,Input.is_action_pressed("shift")],drag_preview)
#		if event.button_index == BUTTON_LEFT and not(event.pressed):
#			var drag_preview = TextureRect.new()
#			drag_preview.set_texture(sprite)
#			drag_preview.rect_size = Vector2(50, 50)
#			force_drag([itemId,self,Input.is_action_pressed("shift")],drag_preview)

