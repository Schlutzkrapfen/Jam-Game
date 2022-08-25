extends Interactable

export var locked = true


func interact():
	if !locked:
		get_parent().queue_free()

