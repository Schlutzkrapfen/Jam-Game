extends RigidBody2D


export var Item_name = "Item"
export var Ammo_amount = 5

func _ready():
	connect("body_entered",self,"code")

func code(body):
	if body.is_in_group("player"):
		body._pick_up(Item_name, Ammo_amount)
		queue_free()
