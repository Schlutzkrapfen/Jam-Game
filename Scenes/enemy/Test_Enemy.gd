extends KinematicBody2D

var speed: float = 200
var acc: float = 1000
var friction = acc / speed
var motion: Vector2 = Vector2()
var player = null
export var damage = 10
export var healt = 10
var death = false
func _ready():
	$AnimationPlayer.play("Idle") 
func _process(delta: float) -> void:
	apply_friction(delta)
	apply_move(delta)
	
func damage(_damage):
	healt -= _damage
	
	
	if healt <= 0:
		death = true
		$AnimationPlayer.play("death")
		player = null
		yield($AnimationPlayer,"animation_finished")
		queue_free()
		return
	$AnimationPlayer.play("damage")
	yield($AnimationPlayer,"animation_finished")
	$AnimationPlayer.play("Run")
	
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
	if body.is_in_group("player") and !death:
		player = body
		$AnimationPlayer.play("Run")
func _on_Area2D2_body_entered(body):
	while body.is_in_group("player")and !death:
		$Hurtbox.look_at(body.position)
		$Hurtbox.rotation_degrees -= 90# I dont understand why i need to use 90 
		$AnimationPlayer.play("attack")
		yield($AnimationPlayer,"animation_finished")
func _on_Area2D2_body_exited(body):
	if body.is_in_group("player")and !death:
		$AnimationPlayer.play("Run")

func _on_Area2D_body_exited(body):
	if body.is_in_group("player")and !death:
		player = null
	
		$AnimationPlayer.play("Idle") 


func _on_Hurtbox_body_entered(body):
	if body.is_in_group("player")and !death:
		body.damage(damage)
