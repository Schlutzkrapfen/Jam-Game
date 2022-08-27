extends KinematicBody2D
export var damage = 10
export var healt = 10
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var navigation = $CollisionShape2D/NavigationAgent2D
var death = false
export var speed: float = 200
var velocity = Vector2.ZERO
var player = null
var did_arrive = false
var Player_Position = Vector2.ZERO
func _ready():
	set_target_location(position)


func set_target_location(target:Vector2) -> void:
	did_arrive = false
	navigation.set_target_location(target)
	
func _on_Area2D_body_entered(body):
	if body.is_in_group("player") and !death:
		player = body
		$Sound_walking.play()
		
		$AnimationPlayer.play("Run")
		
func _physics_process(delta):
	var move_direction = position.direction_to(navigation.get_next_location())
	velocity = move_direction * speed
	navigation.set_velocity(velocity)
	if player != null:
		set_target_location(player.global_position)
	
func _arrived_at_location() -> bool:
	return navigation.is_navigation_finished()


func _on_NavigationAgent2D_velocity_computed(safe_velocity):
	if not _arrived_at_location():
		velocity =move_and_slide(safe_velocity)
	elif not did_arrive:
		#$AnimationPlayer.play("Idle")
		did_arrive = true
		
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
		$Sound_walking.stop()
		set_target_location(body.global_position)
	
		$AnimationPlayer.play("Run") 
func damage(_damage):
	$Sound_damage.play()
	healt -= _damage
	$AnimationPlayer.play("damage")
	if healt <= 0:
		death = true
		player = null
		$Sound_walking.stop()
		$AnimationPlayer.play("death")
		yield($AnimationPlayer,"animation_finished")
		queue_free()
	
func _on_Hurtbox_body_entered(body):
	if body.is_in_group("player")and !death:
		body.damage(damage)



func _on_Shotgun_player_postion(_postion):
 
	set_target_location(_postion)
