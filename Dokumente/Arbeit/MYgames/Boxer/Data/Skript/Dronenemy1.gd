extends KinematicBody2D

var movesmeter = 0
var i = 1
var healt = 4
var randomnummber =RandomNumberGenerator.new()
var shild_nummber = 4
var shild= false
var shildready = false
var boost = 2
var ready = true
var start = false


signal hit1(healt)
signal boost1()

const rocketinstand = preload("res://Data/Gegner/Enemy homing missle1.tscn")

func _physics_process(delta):
	if movesmeter < 7 and start:
		movesmeter += delta
	
	if movesmeter > 5 and ready:
		
		ai()
		
	for i in get_slide_count():# hear should be a more realistic ramsystem
		var collision = get_slide_collision(i)
func handle(damage):
	
	if !shild:
		healt -= damage 
		emit_signal("hit1",healt)
		$AnimationPlayer.play("hit")
		$TextureProgress.value = healt
		yield (get_tree().create_timer(0.2), "timeout")
		$AnimationPlayer.play("standstill")
		if healt <= 0:
			queue_free()

func handle1(damage):
	if !shild:
		
		healt -= damage 
		emit_signal("hit1",healt)
		$AnimationPlayer.play("hit")
		$TextureProgress.value = healt
		yield (get_tree().create_timer(0.2), "timeout")
		$AnimationPlayer.play("standstill")
		if healt <= 0:
			queue_free()

func shild():
	yield(get_tree().create_timer(0.05), "timeout")
	shildready = true
func ai():
	ready = false
	randomnummber.randomize()
	var rocket = randomnummber.randf_range(0, 6.0) 
	
	if rocket > shild_nummber and shildready:
		movesmeter -= 3
		shild = true
		$AnimationPlayer.play("shild")
		yield(get_tree().create_timer(2), "timeout")
		$AnimationPlayer.play("standstill")
		shild = false
	if rocket <shild_nummber and rocket > boost:
		movesmeter -= 5
		
		var rockets = rocketinstand.instance()
		rockets.set_rotation(get_parent().rotation)
		rockets.set_position(get_parent().position)
		get_parent().get_parent().add_child(rockets)
	if rocket < boost:
		
		$AnimationPlayer.play("Boost")
		emit_signal("boost1")
		
		movesmeter -= 4
		yield ($AnimationPlayer,"animation_finished")
		$AnimationPlayer.play("standstill")
	
	ready = true
	

func shildnotneeded():
	shildready = false
 
