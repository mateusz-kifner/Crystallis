extends Control

func _ready():
	LocalPlayer.guiInventory = self.get_path()
	LocalPlayer.customInventory = $Custom.get_path()
