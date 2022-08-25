extends Interactable

onready var door = get_parent().get_parent()

func interact():
	door.get_node("StaticBody2D").locked = false
	get_parent().queue_free()
