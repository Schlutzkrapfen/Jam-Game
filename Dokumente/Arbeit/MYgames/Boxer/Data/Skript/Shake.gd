extends Node

var Camera_shake_intensity = 0.0
var Camera_shake_duration = 0.0

enum Type {Random, noise}
var Camera_shake_type = Type.Random

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func shake(intensity,duration, type = Type.Random):
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
	if intensity > Camera_shake_intensity and duration > Camera_shake_duration:
		Camera_shake_intensity = intensity
		Camera_shake_duration = duration
		Camera_shake_type = type
		
