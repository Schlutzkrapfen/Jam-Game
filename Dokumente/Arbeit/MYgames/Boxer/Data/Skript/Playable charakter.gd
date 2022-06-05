extends KinematicBody2D
class_name Player

const FlOOR_Normal =Vector2.UP

export var gravity: = 30.0


var velocity: = Vector2.ZERO
func _physics_process(delta: float) -> void: 
	velocity.y += gravity * delta

	
