extends KinematicBody2D
var flydirection = 0
var explosion = 1
var positionpunch = 1
var direction = Vector2.ZERO
var speed = Vector2(80.0, 1000.0)
var velocity = Vector2.ZERO
const FlOOR_Normal = Vector2.UP
var gravity = 0
var x = 0
var i = 0
var grabed = false

func _ready():
	$AnimationPlayer.play("Schweben links")
	$Particles2D.restart()
	$Area2D.set_collision_layer(1)
func _physics_process(delta) :
	velocity = calculate_move_velocity(velocity, direction, speed)
	velocity = move_and_slide(velocity, FlOOR_Normal)
	if grabed:
		
		return
	if position.x < 0:
		flydirection = 1
		x += delta/2
	if position.x > 0:
		x -= delta/2
		flydirection = -1
		
	
	direction.x = -x
	gravity =  sin(x*2)/2

	if $Sprite.global_rotation_degrees  <= 45 and $Sprite.global_rotation_degrees  >= -45:
		$Sprite.global_rotation_degrees =-(x *x)/2

func calculate_move_velocity(
	linear_velocity:Vector2,
	speed: Vector2,
	direction: Vector2
	) -> Vector2:
	var new_velocity: = linear_velocity
	new_velocity.x = speed.x * direction.x 
	new_velocity.y = gravity 
	if direction.y == -1.0:
		new_velocity.y = speed.y * direction.y
	return new_velocity


func _on_Area2D_body_entered(body):
	if body.has_method("greifdrone") :
		direction.x = 0
		if grabed:
			$Sprite.global_rotation_degrees = -90* flydirection
			position.x = position.x +10 *flydirection
		if !grabed:
			$Sprite.global_rotation_degrees = 90*flydirection
			position.x = position.x -10*flydirection
		i = 1
		
		body.greifdrone(i,positionpunch)
		grabed = true
		$AnimationPlayer.play("Hacken")
		i = x * flydirection
		while i > 0:
			i-= 0.1
			yield(get_tree().create_timer(0.1), "timeout")
			if i < 0:
				queue_free()
				

	
func knockback(damage):
	grabed = true
	print (damage)
	direction.x = damage * flydirection
	
	$Area2D.set_collision_layer(4)
	$Sprite.global_rotation_degrees =(damage *damage)/2 * flydirection
