extends KinematicBody2D
var explosion = 1
var positionpunch = 1
var direction = Vector2.ZERO
var speed = Vector2(80.0, 1000.0)
var velocity = Vector2.ZERO
const FlOOR_Normal = Vector2.UP
var gravity = 0
var x = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Schweben links")
	$AudioStreamPlayer.play()
	
	
func _physics_process(delta) :
	if position.x < 0:
		x += delta
	if position.x > 0:
		x -= delta
	direction.x = -x
	gravity =  sin(x*2)/2

	velocity = calculate_move_velocity(velocity, direction, speed)
	velocity = move_and_slide(velocity, FlOOR_Normal)
	if $Sprite.global_rotation_degrees  <= 45 and $Sprite.global_rotation_degrees  >= -45:
		$Sprite.global_rotation_degrees =-(x*x) / 2 

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
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	if body.has_method("Ai"):
	
		var damage = 4
		direction.x = 0
		x = 0
		if position.y >0:
			positionpunch = 0
		if position.y <0:
			positionpunch = 2
		
		body.takedamage(damage,positionpunch)
		$AnimationPlayer.play("Explosion")
		$AudioStreamPlayer.stop ()
		yield($AnimationPlayer,"animation_finished")
		queue_free()

