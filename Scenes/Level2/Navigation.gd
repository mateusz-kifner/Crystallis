extends Navigation

func _ready():
	LocalPlayer.navmesh = get_path()
