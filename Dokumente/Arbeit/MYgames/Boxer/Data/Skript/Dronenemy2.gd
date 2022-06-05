extends KinematicBody2D

var movesmeter = 0
var i = 1
var healt = 2
var randomnummber =RandomNumberGenerator.new()
var shild_nummber =  4
var boost = 2
var ready = true
var start = false


signal hit(healt)
signal boost()

const rocketinstand = preload("res://Data/Gegner/Enemy homing missle.tscn")

func _physics_process(delta):
	if movesmeter < 7 :
		movesmeter += delta

	if movesmeter > 5 and ready and start:

		ai()
		
	for i in get_slide_count():# hear should be a more realistic ramsystem
		var collision = get_slide_collision(i)
		print("Collided with: ", collision.collider.name)
func handle(damage):


		
		healt -= damage 
		emit_signal("hit",healt)
		$AnimationPlayer.play("hit")
		$TextureProgress.value = healt
		yield (get_tree().create_timer(0.2), "timeout")
		$AnimationPlayer.play("standstill")
		if healt <= 0:
			queue_free()
func handle2(damage):

		
		healt -= damage 
		emit_signal("hit",healt)
		$AnimationPlayer.play("hit")
		$TextureProgress.value = healt
		yield (get_tree().create_timer(0.2), "timeout")
		$AnimationPlayer.play("standstill")
		if healt <= 0:
			queue_free()


func ai():
	ready = false
	randomnummber.randomize()
	var rocket = randomnummber.randf_range(0, 6.0) 
	
	if rocket > shild_nummber :

		yield(get_tree().create_timer(1), "timeout")
	if rocket <shild_nummber and rocket > boost:

		yield(get_tree().create_timer(0.5), "timeout")

	if rocket < boost:
		
		$AnimationPlayer.play("Boost")
		emit_signal("boost")
		
		movesmeter -= 6
		yield ($AnimationPlayer,"animation_finished")
		$AnimationPlayer.play("standstill")
	
	ready = true
	

