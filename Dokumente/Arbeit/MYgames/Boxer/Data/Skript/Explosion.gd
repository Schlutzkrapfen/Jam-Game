extends Sprite

func _ready():
	$AnimationPlayer.play("Explosion")
	yield($AnimationPlayer,"animation_finished")
	queue_free()
