extends PhysicsBody
class_name InteractiveObject

export var health = 1
export var defense = 0
export var mana = 0
export var title = "UNNAMED"
export var description = ""
export var display_health = false
export var display_mana = false
export var display_interaction = false

export var itemId = 1
export var count = 1


enum DAMAGE_TYPE {
	NONE = 0,
	RECEIVED = 1,
	BLOCKED = 2,
	REDIRECTED = 3
}

enum DAMAGE_PARTICLES {
	NONE = 0,
	WOOD = 1,
	BLOOD = 2,
	GREEN_BLOOD = 3
}


# function to damage stuff
# returns array [damage_type,amount_inflicted,particle_type]
func damage(amount:int):
	return [DAMAGE_TYPE.NONE,0,DAMAGE_PARTICLES.NONE]

# function to destroy stuff
# returns array [damage_type,amount_inflicted,particle_type]
func destroy():
	return [DAMAGE_TYPE.NONE,0,DAMAGE_PARTICLES.NONE]
	
func interact():
	return []

func _ready():
	pass
