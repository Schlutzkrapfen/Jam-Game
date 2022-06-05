extends Player

var box = 0
var blocknum = 1
var lowbox = 6

var gefuehlmeter = 10
var health = 50
var boxhigh = 1
var boxlow = 1
var boxmiddle = 1 
var blocking = true
var block = false
var waittime= 0.1
var enymyinradius = false
var speed = Vector2(80.0, 1000.0)
var direction = Vector2.ZERO
var notblock = true
var boxhit = false
var Blockmade = false
var damagetake = true
var positionpunch = 0
var boxrandomnummer = RandomNumberGenerator.new()
var gewonnen = true
var punchposition = 1
var death = false
var walking = false
var walkingnumber = 0
var y= 0
var playerposition = 0
var skript = false
var walking_direktion = 1

onready var player = get_node("AnimationPlayer")
onready var player2 = get_node("AnimationPlayer2")

signal health_changed_enemy(new_helth)
signal died()
signal blocked()
func _ready():
	$Timer.wait_time = waittime
	player.play("Idle")
	player2.play("stehen")
	walking = true
	movment_skript()

func _physics_process(_delta: float) -> void:
	velocity = calculate_move_velocity(velocity, direction, speed)
	velocity = move_and_slide(velocity, FlOOR_Normal)
	if  playerposition -position.x < 2 :
		walking_direktion =1
		$Sprite2.scale.x = 1
		$Sprite.scale.x = 1
		$Gegnerkopf.scale.x = 1
	if playerposition - position.x >2:
		walking_direktion =-1
		$Sprite2.scale.x = -1
		$Sprite.scale.x = -1
		$Gegnerkopf.scale.x = -1
	if  playerposition -position.x < -40 and skript:
		skript =  false
		walking = true
		$DamageTimer.start()
		yield($DamageTimer,"timeout")
		movment_skript()
	if playerposition - position.x > 40 and skript:
		skript =  false
		walking = true
		
		$DamageTimer.start()
		yield($DamageTimer,"timeout")
		movment_skript()

func calculate_move_velocity(
	linear_velocity:Vector2,
	speed: Vector2,
	direction: Vector2
	) -> Vector2:
	var new_velocity: = linear_velocity
	new_velocity.x = speed.x * direction.x 
	new_velocity.y += gravity * get_physics_process_delta_time()
	if direction.y == -1.0:
		new_velocity.y = speed.y * direction.y
	return new_velocity



func _on_Boxing_range_body_entered(body):
	if body.has_method("Ai"):
		enymyinradius = true
		ai(enymyinradius)
		foot()

func foot():
	while enymyinradius:
		if player.get_current_animation() == ("idle") or player.get_current_animation()==("Charge low") or player.get_current_animation()==("Charge High ")or player.get_current_animation()==("Block unten")or player.get_current_animation()==("Block oben"):
			player2.play("stehen")
		if player.get_current_animation() == ("Box low") or player.get_current_animation() == ("Box High"):
			player2.play("charge")
		yield(get_tree().create_timer(0.1), "timeout")
func ai(enymyinradius):
		player.set_speed_scale(1)
		while enymyinradius and not death :
		
			player.set_speed_scale(1)
			
			if death :
				return
			blocknum = gefuehlmeter /7.5
			if not gewonnen:
				player.play("Idle")
				enymyinradius = false
				player.set_speed_scale(1)
				return
			if Blockmade:
				blocknum = 0
			
			boxrandomnummer.randomize()
			box = boxrandomnummer.randf_range(0, 2.0) 

			
			if box < blocknum:
				damagetake = true
				$Timer.wait_time = 0.2
				if box > 0.2:
					$Timer.wait_time = box
				boxrandomnummer.randomize()
				var highbox = boxrandomnummer.randf_range(0, 12.0) 
				boxrandomnummer.randomize()
				var middlebox = boxrandomnummer.randf_range(0, 12.0) 
				if highbox < lowbox and middlebox < lowbox :
					player.queue("Charge low")
					
					if highbox > box and damagetake:
						positionpunch =0
						player.queue("Box low")
						
					if highbox < box and damagetake:
						positionpunch = 3
						player.queue("Box low")
						

				
				if lowbox < highbox and middlebox < highbox and damagetake:
					positionpunch = 2
					player.queue("Charge High ")
					
					player.queue("Box High")
					

			if blocknum < box:
				var blocksucessful =gefuehlmeter /5
				$Timer.wait_time = box
				boxrandomnummer.randomize()
				var blockunsucessful = boxrandomnummer.randf_range(0, 3.0)
				if blocksucessful > blockunsucessful:
					block = false
					$Timer.start()
					blockglueck(blockunsucessful)
					yield ($Timer,"timeout")
					if Blockmade:
						blocknum = 1
						Blockmade = false
					
				if blocksucessful < blockunsucessful:

					block = true
					Block()
					$Timer.start()
					yield ($Timer,"timeout")
					if Blockmade:
						blocknum = 1
						Blockmade = false
			yield(get_tree().create_timer(box), "timeout")
		
		return 

func boxhit123():
	pass

func _on_Box_body_entered(body):
	if body.has_method("Ai"):
		var damage = box
		body.takedamage(box,positionpunch)

func blockglueck(blocksucessful):
	if death:
		return
	if blocksucessful  <0.75:
		direction.x = -1 * walking_direktion
		player.set_speed_scale(1)
		player2.set_speed_scale(1)
		player.play("roll")
		player2.play("roll")
		
		yield(player,"animation_changed")

		player.advance(1)
		
		direction.x = 0 
		
	if blocksucessful  >=0.75  and blocksucessful <1.5:
		player.queue("Block unten")
		
	if blocksucessful >=1.5:
		player.queue("Block oben")


func Block():
	if death:
		return
	
	if punchposition == 0 or punchposition == 3:
		player.queue("Block unten")
		return
	if punchposition == 1:
		player.queue("Block")
		return
	if punchposition == 2:
		player.queue("Block oben")
		return

func _on_Player_position_changed(new_punchposition):
	punchposition =new_punchposition
	if block:
		boxrandomnummer.randomize()
		var block1 = boxrandomnummer.randf_range(0, 2.0) 
		blockglueck(block1)
		block = false
	

func _on_Area2D_area_entered(area2D):

	if area2D.has_method("block1"):
		blocking = false

func _on_Area2D_area_exited(_area):
	blocking = true
	
func handle(amount, damageposition):
	$Timer2.start()#scheiß lösung
	yield ($Timer2,"timeout")

	if not blocking:
		emit_signal("blocked")
		if punchposition == 2:
			return
		$Block1.set_volume_db((amount-3.5)*1.5 )
		$Block1.play() 
		player.play("Charge High ")
		player2.play("stehen")
		player.animation_set_next("Charge High ","Box High")
		player2.animation_set_next("stehen","charge")
		yield(player,"animation_finished")
	if blocking and death == false:
		
		health -=  amount
		
		#direction.x = +amount/10
		$Particles2D.set_amount(amount*10)
		$Particles2D.set_lifetime(amount/2)
		$Particles2D.process_material.set_param(true,amount *100)
		emit_signal("health_changed_enemy", health)
		if amount > 0.5:
			
			damagetake = false
			direction.x = amount* walking_direktion
			if damageposition== 0 or damageposition== 3:
				player.play("dam unten")
				player2.play("dam unten")
				$"Punch 1".set_volume_db((amount-3.5)*1.5 )
				$"Punch 1".play()
				$Damage.set_volume_db((amount-3.5)*0.5 )
			if damageposition == 2:
				player.play("dam oben")
				player2.play("dam oben")
				$"Punch 1".set_volume_db((amount-3.5)*1.5 )
				$"Punch 1".play()
				$Damage.set_volume_db((amount-3.5)*0.5 )

			yield (get_tree().create_timer(amount/10), "timeout")

			direction.x = 0
			if gefuehlmeter < 12:
				yield(get_tree().create_timer(amount/1.5), "timeout")

				$DamageTimer.wait_time = amount
				walkingnumber = amount/10 * walking_direktion

			if gefuehlmeter >12:
				yield(get_tree().create_timer(amount), "timeout")
				var y= gefuehlmeter/15
				$DamageTimer.wait_time = amount
				walkingnumber = amount/10* walking_direktion 

		
		block = true
	if health < 0 and death == false:
		
		emit_signal("died")
		death = true
		if damageposition== 0 or damageposition== 3 :
			player.clear_queue()
			player2.clear_queue()

			player.play("Death unten")
			player2.play("death unten")
		if damageposition == 2:
			player.play("Death oben")
			player2.play("deth oben")
		direction.x = 0

func blockmade():
	Blockmade = true

func _on_Player_blockingsucessful(_Blockmade):
	blockmade()
	

func _on_Level1_Healt_lvlStartgegner(helth_ganersart):
	health = helth_ganersart
	

func _on_Level1_Heltmeter(healtmeter_start):
	gefuehlmeter = healtmeter_start 

	if gefuehlmeter == 9:
		$Gegnerkopf.modulate = Color(1,1,1,0)
	if gefuehlmeter < 9:
		var x = (-gefuehlmeter/8)+0.975
		$Gegnerkopf.modulate = Color(1,1,1,x)
	if gefuehlmeter > 9:
		var x = ((gefuehlmeter /45)-0.15)+0.43
		$Gegnerkopf.modulate = Color(x,0.24,0.06,1)

func _on_Player_died():
	gewonnen = false

func _on_Button_pressed():
	gefuehlmeter = gefuehlmeter +1 
	

func _on_Button2_pressed():
	gefuehlmeter = gefuehlmeter -1
	


func _on_Settings_menuclosed():
	death = false
	walking = true
	
	$"Sprite/Boxing range/CollisionShape2D".disabled = false


func _on_Settings_menuopen():
	death = true
	enymyinradius =false
	walking = false
	direction.x = 0
	player2.stop()
	player2.play("stehen")
	player.play("Idle")
	
	$"Sprite/Boxing range/CollisionShape2D".disabled = true

func movment_skript():
		
		while walking and death == false: 
			var z = 0
			var x= gefuehlmeter/15
			var walkingrandom= 0
			boxrandomnummer.randomize()
			walkingrandom = boxrandomnummer.randf_range(0, 1.8) 
			z = -y+x -walkingrandom -((playerposition -position.x)*walking_direktion)/360
	
			if z >= 0.5:
				direction.x = -1*walking_direktion
				player.set_speed_scale(1)
				player2.set_speed_scale(1)
				player.play("roll")
				player2.play("roll")
				yield(player,"animation_finished")
				direction.x = 0
			if z >= 0.2 and z < 0.5:
				direction.x = -0.5*walking_direktion
				player.set_speed_scale(0.5)
				player2.set_speed_scale(0.5)
				player.play("Gehen")
				player2.play("Gehen")
			if z >= 0 and z < 0.2:
				direction.x = -0.2*walking_direktion
				player.set_speed_scale(0.2)
				player2.set_speed_scale(0.2)
				player.play("Gehen")
				player2.play("Gehen")
				
			if z  >= -0.2 and z < 0:
				direction.x = 0
				player.play("Block oben")
				player2.play("stehen")
				
				if z < -0.2:
					direction.x = 0.2*walking_direktion
					player.set_speed_scale(direction.x)
					player2.set_speed_scale(direction.x)
					
					player.play("Block oben")
					player2.play("Rückwärts gehen")
			if  playerposition -position.x > -30 and playerposition -position.x < 30:
				
				direction.x = 0
				walking = false
				skript = true
				player.stop()
				player2.stop()
				yield (get_tree().create_timer(2) , "timeout")
	
			if z < 0.5:
				yield (get_tree().create_timer(1), "timeout")

			if  y== walkingnumber:
				walkingnumber= 0
				
			y = walkingnumber 
			
			
			player.set_speed_scale(1)
			player2.set_speed_scale(1)
			
			

func _on_Level1_position1(player):
	playerposition = player





