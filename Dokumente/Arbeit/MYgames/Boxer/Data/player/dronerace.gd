extends KinematicBody2D
var velocity: = Vector2.ZERO
var direction = Vector2.ZERO
export var speed: = Vector2(80.0, 80.0)

var movesmeter = 0
var boost_direction = Vector2.ZERO
var boost = 1
export var boost_now = false
var healt = 2
export var rocket_position = Vector2(0,0)
var rotationsa = 0 
var shild = false
var Zeitlinie = true
var Zeitlinie2 = false
var Zeitlinie3 = false
var rocket1 = false
var Round = 0
var data_lvl = {}

const rocketinstand = preload("res://Data/player/homing missle.tscn")
signal  Roundsover(rounds)
signal dead()

func _ready():
	$AnimationPlayer.play("IDle")

func calculate_move_velocity(
	linear_velocity:Vector2,
	speed: Vector2,
	direction: Vector2
	) -> Vector2:
	
	var new_velocity: = linear_velocity
	new_velocity.x = speed.x * direction.x *boost
	new_velocity.y = speed.y *direction.y * boost
	
	
	return new_velocity


func get_rotation() -> float:
	if direction.x <0 and direction.y <0:
		$Sprite.rotation_degrees = 315
		$Sprite2.rotation_degrees = 315
		$CollisionShape2D.rotation_degrees = 315
		return rotation_degrees
	if direction.x >0 and direction.y <0:
		
		$Sprite.rotation_degrees = 45
		$Sprite2.rotation_degrees = 45
		$CollisionShape2D.rotation_degrees = 45
		return rotation_degrees
	if direction.x <0 and direction.y >0:

		$Sprite.rotation_degrees = 225
		$Sprite2.rotation_degrees = 225
		$CollisionShape2D.rotation_degrees = 225
		return rotation_degrees
	if direction.x >0 and direction.y >0:
		
		$Sprite.rotation_degrees = 135
		$Sprite2.rotation_degrees = 135
		$CollisionShape2D.rotation_degrees = 135
		return rotation_degrees
	
	
	if direction.x <0:
		
		$Sprite.rotation_degrees = 270
		$Sprite2.rotation_degrees = 270
		$CollisionShape2D.rotation_degrees = 270
	if direction.x >0:
		
		$Sprite.rotation_degrees = 90
		$Sprite2.rotation_degrees = 90
		$CollisionShape2D.rotation_degrees = 90
	if direction.y <0:
		
		$Sprite.rotation_degrees = 0
		$Sprite2.rotation_degrees = 0
		$CollisionShape2D.rotation_degrees = 0
	if direction.y >0:
		
		$Sprite.rotation_degrees = 180
		$Sprite2.rotation_degrees = 180
		$CollisionShape2D.rotation_degrees = 180
	
	
	return rotation_degrees

func _physics_process(delta):

	if !boost_now:
		direction = get_direction()
	rotationsa = get_rotation()
	
	if movesmeter < 7:
		movesmeter += delta
		$TextureProgress.value = movesmeter
	if movesmeter > 3 and Input.get_action_strength("Hit"):
		movesmeter -= 3 
		rocket1 = true
		var rocket = rocketinstand.instance()
		rocket.set_rotation(rotationsa)
		rocket.set_position(position)
		get_parent().add_child(rocket)
		
	if movesmeter > 4 and Input.get_action_strength("Block"):
		movesmeter -= 4 
		shild = true
		$AnimationPlayer.play("Schild")
		yield(get_tree().create_timer(2), "timeout")
		$AnimationPlayer.play("IDle")
		shild = false
		
	if movesmeter > 5 and Input.get_action_strength("roll")> 0.5 and ! boost_now:#boost
		if direction.x <0:
			direction.x = -2
		if direction.x >0:
			direction.x = 2
		if direction.y <0:
			direction.y = -2
		if direction.y >0:
			direction.y = 2
		movesmeter -= 5
		$AnimationPlayer.play("boost")
		boost_now = true
		yield(get_tree().create_timer(1), "timeout")
		boost_now = false
		boost = 1
		$AnimationPlayer.play("IDle")
	velocity = calculate_move_velocity(velocity, direction, speed)
	velocity = move_and_slide(velocity)
		

func get_direction () -> Vector2:
	
		
		return Vector2(
			Input.get_action_strength("Move_right") - Input.get_action_strength("Move_left"), 
			Input.get_action_strength("down(drone)") -Input.get_action_strength("up(drowne)")
			)

func handle1(damage):
	$AnimationPlayer.play("hit")
	healt -= 1
	boost = 0.1 
	yield(get_tree().create_timer(0.2), "timeout")
	$AnimationPlayer.play("IDle")
	boost = 1 
	$Sprite/TextureProgress2.value = healt
	if healt <= 0:
		emit_signal("dead")
		queue_free()

func handle2(damage):
	$AnimationPlayer.play("hit")
	healt -= 1
	boost = 0.1 
	yield(get_tree().create_timer(0.2), "timeout")
	$AnimationPlayer.play("IDle")
	boost = 1 
	$Sprite/TextureProgress2.value = healt
	if healt <= 0:
		emit_signal("dead")
		queue_free()


func _on_Area2D_body_entered(body):
	if body.has_node("startline")and Zeitlinie3:
		Zeitlinie3 = false
		Zeitlinie = true
		Round += 1
		print (Round)
		if Round == 2:
			print (Round)
			emit_signal("Roundsover")
			print (Round)
			
	if body.has_node("1 zeitlinie") and Zeitlinie:
		Zeitlinie = false
		Zeitlinie2 =true
		print (3)
	if body.has_node("2 Zeitline") and Zeitlinie2:
		Zeitlinie2 = false
		Zeitlinie3 =true
		print(4)



