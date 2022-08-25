extends RigidBody2D
export var damage = 1


func _on_Bullet_body_entered(body):
	if body.is_in_group("enemy"):
		body.damage(damage)
	if !body.is_in_group("player") and !body.is_in_group("bullet") :# if something isnt in the playergroup
		queue_free()
