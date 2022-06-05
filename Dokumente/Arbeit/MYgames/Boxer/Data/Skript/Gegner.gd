extends Player

var gefuehlmeter = 10
var health = 10
var x: int = 0
var boxhigh = 1
var boxlow = 1

var waittime= 0.1

var speed: = Vector2(80.0, 1000.0)
var direction = Vector2.ZERO
var notblock = true
var boxhit = false
var boxrandomnummer = RandomNumberGenerator.new()
onready var player = get_node("AnimationPlayer")


func _on_Area2D_body_entered(body):
	if body.has_method("Ai"):
		if gefuehlmeter == 10:
			direction.x = -1
			return


func _physics_process(_delta: float) -> void:
	velocity = calculate_move_velocity(velocity, direction, speed)
	velocity = move_and_slide(velocity, FlOOR_Normal)

func calculate_move_velocity(
	linear_velocity:Vector2,
	speed: Vector2,
	direction: Vector2
	) -> Vector2:
	var new_velocity: = linear_velocity
	new_velocity.x = speed.x * direction.x 
	new_velocity.y += gravity * get_physics_process_delta_time()
	if direction.y == -1.0:
		new_velocity.y = speed.y * direction.y
	return new_velocity

func _on_Area2D_body_exited(body):
	if body.has_method("Ai"):
			direction.x = 0

func _on_Boxing_range_body_entered(body):
	if body.has_method("Ai"):
		while health > 0:
			boxrandomnummer.randomize()
			var lowbox = boxrandomnummer.randf_range(0, 10.0) * boxlow 
			boxrandomnummer.randomize()
			var highbox = boxrandomnummer.randf_range(0, 10.0) * boxhigh 
			if highbox > lowbox:
				player.play("Box 2")
				boxhigh = boxhigh - 0.1
				$Timer.start()
				yield (player,"animation_finished")
				yield ($Timer,"timeout")
			if lowbox  > highbox:
				player.play("Box")
				boxlow = boxlow - 0.1
				$Timer.start()
				
				yield (player,"animation_finished")
				yield ($Timer,"timeout")

func handle(amount):
	
	health = health - amount
	print (health)
	if health < 0:
		queue_free()

func boxhit123():
	pass

func block(new_punchposition):
	pass
func _on_Box_body_entered(body):
	if body.has_method("Ai"):
		body.takedamage(1)
		
func _on_KinematicBody2D_position_changed(new_punchposition):
	block(new_punchposition)
