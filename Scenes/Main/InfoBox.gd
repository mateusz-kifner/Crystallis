extends VBoxContainer

export var image:String setget set_image
export var itemLabel = "" setget set_label
export var description = "" setget set_description
export var itemId = -1
var sprite:Texture

func _ready():
	Items.info_box_instance = get_path()

func set_sprite(val):
	sprite = load(Items.path_to_item_icons + val)
	set_image(sprite)

func set_image(val):
	$CenterContainer/TextureRect.set_texture(val)
	
func set_label(val):
	$ItemName.text = val
	
func set_description(val):
	$Description.text = val
