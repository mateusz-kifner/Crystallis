extends CenterContainer


func _ready():
	LocalPlayer.Cursor = $TextureRect.get_path()
