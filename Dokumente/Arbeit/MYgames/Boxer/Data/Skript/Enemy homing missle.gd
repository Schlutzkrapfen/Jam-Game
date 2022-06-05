extends Area2D

export var speed = 250
export var rotationspeed = 1.5
export var damage = 1 

var positions_start = Vector2.ZERO
export(PackedScene) var explosion_fx
onready var target = get_node("../../Path2D/PathFollow2D") as Node2D
onready var target_rocket = get_node("../../Path2D/PathFollow2D/KinematicBody2D")

onready var target1 = get_node("../../droneplayer") as Node2D
var rotations = 0

func _ready():
	
	$AnimationPlayer.play("Idle")
	positions_start = get_node("../..").position
	rotations = get_node("../PathFollow2D").rotation_degrees
	rotation_degrees = rotations +90
	if target.get_child_count() == 1:
		target_rocket.shild()
func _process(delta):

	if target.global_position.distance_to(global_position) <target1.global_position.distance_to(global_position):
	
		var direction = target.position -(position) 
		direction = direction.normalized()
			
		var rotationsamount = direction.cross(transform.y)
		rotate(rotationsamount *rotationspeed* delta)
		global_translate(-transform.y* speed *delta)
	if target.global_position.distance_to(global_position) >target1.global_position.distance_to(global_position):
		
		var direction = target1.position -(position) 
		direction = direction.normalized()
	
		var rotationsamount = direction.cross(transform.y)
		rotate(rotationsamount *rotationspeed* delta)
		global_translate(-transform.y* speed *delta)


func _on_Area2D_body_entered(body):
	if body.has_method("handle1") :
		var explosion = explosion_fx.instance()
		explosion.position = position
		get_parent().add_child(explosion)
		body.handle1(damage)
		if target.get_child_count() == 1:
			target_rocket.shildnotneeded()
		
		queue_free()
