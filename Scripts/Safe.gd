extends Interactable

var opend = false

func interact():
	if opend:
		get_parent().get_node("Gold").queue_free()
		Game.gold += 50
		queue_free()
	get_parent().get_node("AnimatedSprite").play("default")
	opend = true
