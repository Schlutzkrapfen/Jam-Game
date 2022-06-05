extends Player

var healt = 100
var highint = 10
var lowint = 20
var damagemultiplyer = 1
var speed: = Vector2(80.0, 1000.0)
var state_machine
var blocking = true
var block = false
var punch = false
var movement = false
var walkdirection = true
var changedirection = false
var duration_pressed = 0
var moving =Vector2(0,0)
var blockspeed = 1
var movmentspeed = 1
var punchposition = 0 # 0 unten 1 mitte 2 oben
var mouseposition = 0 # 0 unten 1 mitte 2 oben
var damageposition = 0 # 0 unten 1 mitte 2 oben 3 upercut
var blockmade = true
var damagetaken= true
var punchischarged = false
var death = true
var soundeffekts = 1

enum Type {Random, punchs}
var Camera_shake_type = Type.Random
#onready var camera = $Camera2D
signal camara(intensity,duration, type )
signal position_changed(new_punchposition)
signal blockingsucessful(new_Blockmade)
signal health_changed(new_helth)
signal died()

func _ready():
	
	state_machine = $AnimationTree.get("parameters/playback")

func _physics_process(_delta: float) -> void: ##movment and animations 

	var direction:= get_direction() 
	var Mouse_pos = get_local_mouse_position()
	if direction.x > Mouse_pos.x:##charackter dirktion
		if death:
			$Sprite.scale.x = -1
			$Sprite.position = Vector2(-8,0) 
			$Sprite2.scale.x = -1
			$Sprite2.position = Vector2(-8,0) 
		if direction.x > 0: 
			movmentspeed = 0.75
			if walkdirection:
				changedirection = true
			walkdirection = false
		if direction.x < 0: 
			movmentspeed = 1
			if walkdirection == false:
				changedirection = true
			walkdirection = true
	elif direction.x < Mouse_pos.x:
		if death:
			$Sprite2.scale.x = 1
			$Sprite.scale.x = 1
			$Sprite.position = Vector2(8,0)
			$Sprite2.position = Vector2(8,0)
		if direction.x > 0: 
			movmentspeed = 1
			if walkdirection == false:
				changedirection = true
			walkdirection = true
		if direction.x < 0: 
			movmentspeed = 0.75
			if walkdirection:
				changedirection = true
			walkdirection = false
	if damagetaken:
		if direction.y > Mouse_pos.y :
			mouseposition = 2
			if block:
				state_machine.travel("Block")
				$AnimationTree.set("parameters/Block/position/blend_amount",0)
				$AnimationTree.set("parameters/Block/Seek 2/seek_position",0)
				$AnimationTree.set("parameters/Block/Seek 3/seek_position",0)
				$AnimationTree.set("parameters/Block/Seek/seek_position",0)
				$AnimationTree.set("parameters/Block/position/blend_amount",+1)
				if direction.x == 0 or movement == false:
					$AnimationTree.set("parameters/Block/Moving/add_amount",0)
					$AnimationTree.set("parameters/Block/Stehen/add_amount",1)
					movement = true
				if (direction.x != 0 and movement) or changedirection:
					$AnimationTree.set("parameters/Block/Stehen/add_amount",0)
					if walkdirection:
						$AnimationTree.set("parameters/Block/Moving/add_amount",1)
					
					if walkdirection == false:
						$AnimationTree.set("parameters/Block/Moving/add_amount",-1)
					movement = false
					changedirection = false
		if direction.y < Mouse_pos.y :
			mouseposition = 0
			if block:
				state_machine.travel("Block")
				$AnimationTree.set("parameters/Block/position/blend_amount",-1)
				if direction.x == 0 or movement == false:
					$AnimationTree.set("parameters/Block/Moving/add_amount",0)
					$AnimationTree.set("parameters/Block/Stehen/add_amount",1)
				movement = true
				if (direction.x != 0 and movement) or changedirection:
					$AnimationTree.set("parameters/Block/Stehen/add_amount",0)
					movement = true
					if walkdirection:
						$AnimationTree.set("parameters/Block/Moving/add_amount",1)
					
					if walkdirection == false:
					
						$AnimationTree.set("parameters/Block/Moving/add_amount",-1)
					movement = false
					changedirection = false

			
	velocity = calculate_move_velocity(velocity, direction, speed)
	velocity = move_and_slide(velocity, FlOOR_Normal)
	if Input.is_action_pressed("Hit"):
		
		duration_pressed += _delta
		if damagetaken:
			punch = true
	if Input.is_action_just_released("Hit"):
		if damagetaken:
			punch = false
		duration_pressed = 0
		blockspeed = 1
	
	if punch == false and damagetaken:
		if direction.x == 0 and movement == false:
			state_machine.travel("idle")
			$AnimationTree.set("parameters/Idle/Blend3/blend_amount",0)
			$AnimationTree.set("parameters/Idle/Stehen/add_amount",1)
			$AnimationTree.set("parameters/Charge/Moving/add_amount",0)
			movement = true
		#print(direction.x, movement,changedirection,walkdirection)
		if (direction.x != 0 and movement) or changedirection:
			
			if walkdirection:
				$AnimationTree.set("parameters/Idle/Blend3/blend_amount",1)
				$AnimationTree.set("parameters/Idle/Stehen/add_amount",0)
				$AnimationTree.set("parameters/Charge/Moving/add_amount",1)

			if walkdirection == false:
				$AnimationTree.set("parameters/Idle/Blend3/blend_amount",-1)
				$AnimationTree.set("parameters/Idle/Stehen/add_amount",0)
				$AnimationTree.set("parameters/Charge/Moving/add_amount",-1)
			
			movement = false
			changedirection = false
	if punch and damagetaken:
		if direction.x == 0 and movement == false:
			$AnimationTree.set("parameters/Charge/Moving/add_amount",0)
			movement = true
		if (direction.x != 0 and movement) or changedirection:
			if walkdirection:
				$AnimationTree.set("parameters/Charge/Moving/add_amount",1)
				# wenn man es nicht so tut startet die animation von vorne # passiert immer noch versteh nicht wiso
			if walkdirection == false:
				$AnimationTree.set("parameters/Charge/Moving/add_amount",-1)
			movement = false
			changedirection = false
			
	if punch and punchischarged:
		duration_pressed = duration_pressed + _delta
func get_direction () -> Vector2:
	
	return Vector2(
		Input.get_action_strength("Move_right") - Input.get_action_strength("Move_left"), 
		-1.0 if Input.is_action_just_pressed("Jump") and is_on_floor() 
		else 1.0
	)

func calculate_move_velocity(
	linear_velocity:Vector2,
	speed: Vector2,
	direction: Vector2
	) -> Vector2:
	
	var new_velocity: = linear_velocity
	new_velocity.x = speed.x * direction.x * blockspeed * movmentspeed
	new_velocity.y += gravity * get_physics_process_delta_time()
	
	if direction.y == -1.0:
		new_velocity.y = speed.y * direction.y
	return new_velocity

func _input(_event):##block 

	if Input.is_action_just_pressed("Block") :
		block = true
		blockspeed = 0.4##wieviel längsemer der charakter wird
	if Input.is_action_just_released("Block"):
		blockspeed = 1
		block = false
		if damagetaken:
			state_machine.travel("Idle")
	if Input.is_action_just_pressed("Hit"):
		if damagetaken:

			state_machine.travel("Charge")
			punchischarged = true
			if mouseposition == 1:
			
				$AnimationTree.set("parameters/Charge/position/blend_amount",0)
				duration_pressed = 0
				punchposition = 1
			if mouseposition == 2:
				$AnimationTree.set("parameters/Charge/position/blend_amount",1)
				duration_pressed = 0
				punchposition = 2
			if mouseposition == 0:
				$AnimationTree.set("parameters/Charge/position/blend_amount",-1)
				duration_pressed = 0
				punchposition = 0
			
		
		emit_signal("position_changed",punchposition)
		blockspeed = 0.2
			
		
	if Input.is_action_just_released("Hit"):
		if punch and punchischarged:
			punch = false
			punchischarged = false
			damagemultiplyer = duration_pressed
			
			if punchposition == 1:
				damageposition = 1
				state_machine.travel("Box")
				if damagemultiplyer > 0.5:
					$"woosch1 sound".play()
			if punchposition == 0 and mouseposition == 2:
				damageposition = 3
				state_machine.travel("Box low")
				if damagemultiplyer > 0.5:
					$"woosch sound 2".play()
			if punchposition == 0 and mouseposition== 0 or punchposition == 0 and mouseposition == 1:
				damageposition = 0
				state_machine.travel("Box low")
				if damagemultiplyer > 0.5:
					$"woosch sound".play()
			if punchposition == 2 :
				damageposition = 2
				state_machine.travel("Box High")
				if damagemultiplyer > 0.5:
					$"woosch sound".play()
			emit_signal("camara", 0.2 * damagemultiplyer,0.3,Type.punchs)


func Ai():
	pass

func takedamage(amount,positionpunch):
	print(positionpunch)
	$Timer2.start()
	yield ($Timer2,"timeout")#Bitte finde einen besseren weg als das hier #es wird gewartet bis das blocken erkennt wird
	if blocking:
		healt -=amount 
		emit_signal("camara",0.2* amount,amount/2,Type.Random)
	if healt < 0:
		damagetaken = false
		blockspeed = 0
		if death:
			$Particles2D.set_amount(amount*10)
			$Particles2D.set_lifetime(amount/2)
			$Particles2D.process_material.set_param(true,amount *100)
			if positionpunch == 0 or positionpunch == 3:
				$AnimationTree.set("parameters/Deth/Blend3/blend_amount",-1)
				$AnimationTree.set("parameters/Deth/Blend2/blend_amount",0)
				state_machine.travel("Deth")
				if amount > 0.25:
					$Punch_sound.set_volume_db((amount-3.5)*4 )
					$Punch_sound.play()
				if amount < 0.25:
					$Punch_sound1.set_volume_db((amount-3.5)*4 )
					$Punch_sound1.play()
				$Death1.set_volume_db((amount-3.5)*4 )
				$Death1.play()
				yield(get_tree().create_timer(0.9), "timeout")
			if positionpunch == 1:
				$AnimationTree.set("parameters/Deth/Blend3/blend_amount",0)
				state_machine.travel("Deth")
				if amount > 0.25:
					$Punch_sound.set_volume_db((amount-3.5)*4 )
					$Punch_sound.play()
				if amount < 0.25:
					$Punch_sound1.set_volume_db((amount-3.5)*4 )
					$Punch_sound1.play()
				$Death.set_volume_db((amount-3.5)*4 )
				$Death.play()
				yield(get_tree().create_timer(0.9), "timeout")
			if positionpunch == 2:
				$AnimationTree.set("parameters/Deth/Blend3/blend_amount",1)
				state_machine.travel("Deth")
				if amount > 0.25:
					$Punch_sound.set_volume_db((amount-3.5)*4 )
					$Punch_sound.play()
				if amount < 0.25:
					$Punch_sound1.set_volume_db((amount-3.5)*4 )
					$Punch_sound1.play()
				$Death1.set_volume_db((amount-3.5)*4 )
				$Death1.play()
				yield(get_tree().create_timer(0.4), "timeout")
			#if positionpunch == 3:
			#	$AnimationTree.set("parameters/Deth/Blend3/blend_amount",-1)
			#	$AnimationTree.set("parameters/Deth/Blend2/blend_amount",1)
			#	state_machine.travel("Deth")
			#	if amount > 0.25:
			#		$Punch_sound.set_volume_db((amount-3.5)*4 )
			#		$Punch_sound.play()
			#	if amount < 0.25:
			#		$Punch_sound1.set_volume_db((amount-3.5)*4 )
			#		$Punch_sound1.play()
			#	$Death.set_volume_db((amount-3.5)*4 )
			#	$Death.play()
			#	yield(get_tree().create_timer(0.5), "timeout")
	
		death = false
			
		
			
		
		emit_signal("died")
		$AnimationTree.active = false
			
		return
	if blocking:
		$Particles2D.set_amount(amount*10)
		$Particles2D.set_lifetime(amount/2)
		$Particles2D.process_material.set_param(true,amount *100)
		$DamageTimer.wait_time =amount
		$DamageTimer.start()
		damagetaken= false
		punchischarged = false
		if positionpunch == 0 or positionpunch ==3:
			$AnimationTree.set("parameters/Damage/Blend3/blend_amount",-1)
			$AnimationTree.set("parameters/Damage/Blend2/blend_amount",0)
			if amount > 0.25:
				$Punch_sound.set_volume_db((amount-3.5)*2 )
				$Punch_sound.play()
			if amount < 0.25:
				$Punch_sound1.set_volume_db((amount-3.5)*2 )
				$Punch_sound1.play()
			$"damage 1".set_volume_db((amount-3.5)*2 )
			$"damage 1".play()
		if positionpunch == 1:
			$AnimationTree.set("parameters/Damage/Blend3/blend_amount",0)
			if amount > 0.25:
				$Punch_sound.set_volume_db((amount-3.5)*2 )
				$Punch_sound.play()
			if amount < 0.25:
				$Punch_sound1.set_volume_db((amount-3.5)*2 )
				$Punch_sound1.play()
			$damage.set_volume_db((amount-3.5)*2 )
			$damage.play()
		if positionpunch == 2:
			$AnimationTree.set("parameters/Damage/Blend3/blend_amount",1)
			if amount > 0.25:
				$Punch_sound.set_volume_db((amount-3.5)*2 )
				$Punch_sound.play()
			if amount < 0.25:
				$Punch_sound1.set_volume_db((amount-3.5)*2 )
				$Punch_sound1.play()
			$"damage 1".set_volume_db((amount-3.5)*2 )
			$"damage 1".play()
		#if positionpunch == 3:
		#	$AnimationTree.set("parameters/Damage/Blend3/blend_amount",-1)
		#	$AnimationTree.set("parameters/Damage/Blend2/blend_amount",1)
		#	if amount > 0.25:
		#		$Punch_sound.set_volume_db((amount-3.5)*2 )
		#		$Punch_sound.play()
		#	if amount < 0.25:
		#		$Punch_sound1.set_volume_db((amount-3.5)*2 )
		#		$Punch_sound1.play()
		#	$damage.set_volume_db((amount-3.5)*2 )
		#	$damage.play()
		state_machine.travel("Damage")
		
		emit_signal("health_changed",healt)
		blockspeed = 0.1
		
		
		yield($DamageTimer,"timeout")
		damagetaken= true
		duration_pressed = 0
		blockspeed = 1
		state_machine.travel("Idle")
		return
		
	else:
		emit_signal("blockingsucessful",blockmade)
		$"Block".play()

func _on_Punch_body_entered(body):
	if body.has_method("handle") :
		body.handle(damagemultiplyer,damageposition)

func _on_Block_area_entered(area2D):
	if area2D.has_method("block"):
		blocking = false
		emit_signal("blockingsucessful",blockmade)

func _on_Block_area_exited(_area2D):
	
	blocking = true


func _on_Level1_Healt_lvlStart(helth_lvlstart):
	healt = helth_lvlstart



func _on_Settings_menuopen():
	$AnimationTree.active = false
	blockspeed = 0
	death = false
	blockspeed = 0



func _on_Settings_menuclosed():
	death = true
	$AnimationTree.active = true
	blockspeed = 1


func _on_rolling_joe_health_changed_enemy(new_helth):
	emit_signal("camara",0.6,0.3,Type.punchs)


