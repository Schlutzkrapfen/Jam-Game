extends Area2D
export var speed = 250
export var rotationspeed = 1.5
export var damage = 1 

var positions_start = Vector2.ZERO
export(PackedScene) var explosion_fx
onready var target = get_node("../Path2D2/PathFollow2D") as Node2D
var rotations = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Idle")
	positions_start = get_node("..").position
	rotations = get_node("../KinematicBody2D2/Sprite").rotation_degrees
	rotation_degrees = rotations

func _process(delta):
	
		var direction = target.position -(position) 
		direction = direction.normalized()
		
		var rotationsamount = direction.cross(transform.y)
		rotate(rotationsamount *rotationspeed* delta)
		global_translate(-transform.y* speed *delta)



func _on_Area2D_body_entered(body):
	if body.has_method("handle") :
		var explosion = explosion_fx.instance()
		explosion.position = position
		get_parent().add_child(explosion)
		body.handle(damage)

		queue_free()
