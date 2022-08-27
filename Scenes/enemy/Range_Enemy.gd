extends KinematicBody2D
export var damage = 5
export var healt = 10
export var bulletspread:float = 0.4
export var bullets:int = 2
export var bullet_speed = 400
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var navigation = $CollisionShape2D/NavigationAgent2D
var death = false
export var speed: float = 200
var velocity = Vector2.ZERO
var player = null
var player1 = null
var did_arrive = false
var Player_Position = Vector2.ZERO
var bulletspreadgenerator = RandomNumberGenerator.new()

func _ready():
	set_target_location(position)
var bullet = preload("res://Scenes/enemy/Enemy_Bullet.tscn")

func set_target_location(target:Vector2) -> void:
	did_arrive = false
	navigation.set_target_location(target)
	
func _on_Area2D_body_entered(body):
	if body.is_in_group("player") and !death:
		player = body
		
		
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
		$AnimationPlayer.play("Idle")
		did_arrive = true
		
func _on_Area2D2_body_entered(body):
	while body.is_in_group("player")and !death:
		player1 = body
		
		player = null

		$AnimationPlayer.play("attack")
		yield(get_tree().create_timer(.8), "timeout")
		shoot()
		yield($AnimationPlayer,"animation_finished")
func _on_Area2D2_body_exited(body):
	if body.is_in_group("player")and !death:
		$AnimationPlayer.play("Run")
func _on_Area2D_body_exited(body):
	if body.is_in_group("player")and !death:
		player = null
		set_target_location(body.global_position)
	
		$AnimationPlayer.play("Run") 
func damage(_damage):
	healt -= _damage
	
	if healt <= 0:
		death = true
		player = null
		$AnimationPlayer.play("death")
		yield($AnimationPlayer,"animation_finished")
		queue_free()
	$AnimationPlayer.play("damage")



func _on_Shotgun_player_postion(_postion):
 
	set_target_location(_postion)

func  shoot():
	print(player1)
	for number in range(bullets,0,-1):
		var bullet_instance = bullet.instance()
		bullet_instance.position = $end_of_weapon.get_global_position() 
		bullet_instance.damage = damage
		bulletspreadgenerator.randomize()
		var random = bulletspreadgenerator.randf_range(-bulletspread,bulletspread)
		$end_of_weapon.look_at(player1.position)
		bullet_instance.rotation = ($end_of_weapon.rotation+random)
		bullet_instance.apply_impulse(Vector2(),Vector2(bullet_speed,0).rotated($end_of_weapon.rotation+random))
		get_tree().get_root().add_child(bullet_instance)
