extends RigidBody2D


export var Item_name = "Item"
export var Ammo_amount = 5
signal player_postion(_postion)

func _ready():
	connect("body_entered",self,"code")
	
func code(body):
	if body.is_in_group("player"):
		emit_signal("player_postion",global_position)
		body._pick_up(Item_name, Ammo_amount)
		queue_free()
