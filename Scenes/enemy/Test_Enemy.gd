extends KinematicBody2D

var speed: float = 200
var acc: float = 1000
var friction = acc / speed
var motion: Vector2 = Vector2()
var player = null
export var healt = 10

func _process(delta: float) -> void:
	apply_friction(delta)
	apply_move(delta)
	
func damage(damage):
	healt -= damage
	if healt < 0:
		queue_free()
	
func _physics_process(delta: float) -> void:
	motion = move_and_slide(motion)
	
func apply_move(delta: float) -> void:
	var move: Vector2 = Vector2()
	if player:
		motion = position.direction_to(player.position) * speed
	move = move.normalized()
	motion += move * acc * delta
func apply_friction(delta: float) -> void:
	motion -= motion * friction * delta
func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		player = body
	$AnimatedSprite.animation = "run"
func _on_Area2D_body_exited(body):
	player = null
	$AnimatedSprite.animation = "idle"
func _on_Area2D2_body_entered(body):
	$AnimatedSprite.animation = "attack"
func _on_Area2D2_body_exited(body):
	$AnimatedSprite.animation = "idle2"
