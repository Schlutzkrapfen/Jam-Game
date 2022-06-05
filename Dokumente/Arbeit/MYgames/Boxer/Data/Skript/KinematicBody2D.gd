extends KinematicBody2D


# extends KinematicBody2D


onready var volicity = Vector2(-5,0)




func _physics_process(_delta):
	move_and_slide(volicity)
	if position.x <-1000:
		queue_free()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
