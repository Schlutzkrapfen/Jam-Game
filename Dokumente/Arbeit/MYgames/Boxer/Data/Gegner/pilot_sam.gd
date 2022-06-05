extends Player
export var fly_lenght = 6
export var fly_speed = 50
var box = 0
var blocknum = 1
var lowbox = 6
var drone_1 = 4
var place_1 = 6
var fliegen_Start = false
var fliegen_ende = false

var gefuehlmeter = 10
var health = 20
var boxhigh = 1
var boxlow = 1
var blocking = true
var block = false
var waittime= 0.1
var enymyinradius = true
export var speed = Vector2(80.0, 1000.0)
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
var fliegen = false #that the animation wont play more times
var grabed = false
var walking_direktion = 1
var highdroneE =Vector2 (-17,-19.5)
var lowdroneE = Vector2(-21,-7.5)
var highdroneG =Vector2 (-11,-18.5)
var lowdroneG = Vector2(-18.5,-5)
var crying = false
onready var player = get_node("AnimationPlayer")
onready var player2 = get_node("AnimationPlayer2")

var i = 1 

const Drone = preload("res://Data/Gegner/explosive drone.tscn")
const Greifdrone = preload("res://Data/Gegner/greifdrone.tscn")

signal health_changed_enemy(new_helth)
signal died()



func greifdrone(x,y):
	
	$AnimationPlayer.play("schwindelig")
	$AnimationPlayer2.play("Schwindelig")
	grabed = true
	yield(get_tree().create_timer(2), "timeout")
	
	grabed = false
	

func _ready():

	
	$Timer.wait_time = waittime
	player.play("Idle")
	player2.play("stehen")
	walking = true
	
	enymyinradius = true
	
	yield(get_tree().create_timer(0.75), "timeout")
	if crying :
		player.play("crying")
		player2.play("stehen")
		return
	ai(enymyinradius)
	


func _physics_process(_delta: float) -> void:

	velocity = calculate_move_velocity(velocity, direction, speed)
	velocity = move_and_slide(velocity, FlOOR_Normal)
	if  playerposition -position.x < 2 and !fliegen :
		walking_direktion =1
		$Sprite2.scale.x = -1
		$Sprite.scale.x = -1
		$propeller.scale.x = -1
		highdroneE.x = -13
		lowdroneE.x = -21
		highdroneG.x =-11
		lowdroneG.x = -18.5
	if playerposition - position.x >2 and !fliegen:
		walking_direktion =-1
		$Sprite2.scale.x = 1
		$Sprite.scale.x = 1
		$propeller.scale.x = 1
		highdroneE.x = 13
		lowdroneE.x = 21
		highdroneG.x =11
		lowdroneG.x = 18.5
		
	if (playerposition-position.x) < 20 and (playerposition-position.x) >-20 and !death and !crying :
		yield (get_tree().create_timer(2), "timeout")
		if !fliegen and (playerposition-position.x) < 20 and (playerposition-position.x) >-20 :
			fliegen()
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

func fliegen():#flying
	fliegen = true
	player2.play("stehen")
	player.play("probeller ausfahren")
	yield(player,"animation_finished")
	fliegen_Start = true
	player.play("Fliegen")
	
	while fliegen:
		if direction.x > fly_lenght or direction.x < -fly_lenght:
			fliegen_ende = true
		
		if direction.x >=0 and !fliegen_ende or direction.x <0 and !fliegen_ende :
			direction.x = direction.x +get_process_delta_time() *fly_speed *-walking_direktion
			if direction.x > 1 or direction.x < -1:
				var skale = Vector2(direction.x,direction.x *- walking_direktion)
				$Sprite.rotate(direction.x/1000)
				$Sprite2.rotate(direction.x/1000)
				$propeller.rotate(direction.x/1000)
				$Sprite.scale = skale
				$Sprite2.scale = skale
				$propeller.scale = skale
				
		if  direction.x >=0 and fliegen_ende or direction.x <0 and fliegen_ende :
			direction.x = direction.x +get_process_delta_time() *fly_speed *walking_direktion
			if direction.x > 1 or direction.x < -1:
				var skale = Vector2(direction.x ,direction.x *- walking_direktion)
				$Sprite.rotate(direction.x/1000)
				$Sprite2.rotate(direction.x/1000)
				$propeller.rotate(direction.x/1000)
				$Sprite.scale = skale
				$Sprite2.scale = skale
				$propeller.scale = skale
				
		if direction.x >= -0.5 and fliegen_ende and direction.x <0.5:
			direction.x  = 0
			
			fliegen_ende = false
			
			$Sprite.rotate(0)
			$Sprite2.rotate(0)
			$propeller.rotate(0)
			var skale = Vector2(1,1)
			$Sprite.scale = skale
			$Sprite2.scale = skale
			$propeller.scale =skale
			$AnimationPlayer.play("propeller eingahren")
			
			yield (player,"animation_finished")
			player.play("Idle")
			player2.play("stehen")
			fliegen = false
			break
		yield(get_tree().create_timer(0.05), "timeout")
	
	
	

	if $Sprite.global_rotation_degrees  <= 45 and $Sprite.global_rotation_degrees  >= -45:
		$Sprite.global_rotation_degrees =-i
		$Sprite2.global_rotation_degrees =-i
		$propeller. global_rotation_degrees =-i


func ai(enymyinradius):
	player.set_speed_scale(1)
	yield(get_tree().create_timer(0.25), "timeout")
	while  i > 0:
		boxrandomnummer.randomize()
		var drone = boxrandomnummer.randf_range(3, 5.0) 
		if !grabed and !fliegen and !death and !crying:

			boxrandomnummer.randomize()
			var place = boxrandomnummer.randf_range(0, 12.0) 
			if drone < drone_1:

				player2.play("Schlagen")
				var Graifdrone = Greifdrone.instance()
				if place < place_1:
					player.play("Box High G")
					$grabdrone.position = Vector2(7*-walking_direktion,-4)
					yield(get_tree().create_timer(0.2), "timeout")
					$grabdrone.position = Vector2(11*-walking_direktion,-18.5)
					yield(player,"animation_finished")
					Graifdrone.set_position(highdroneG)
					
				if place > place_1:
					player.play("Box low G")
					$grabdrone.position = Vector2(6*-walking_direktion,-4)
					yield(get_tree().create_timer(0.2), "timeout")
					$grabdrone.position = Vector2(18.5*-walking_direktion,-5)
					yield(player,"animation_finished")
					Graifdrone.set_position(lowdroneG)
					
				add_child(Graifdrone)
					
			elif drone> drone_1:
				player2.play("Schlagen")
				var Explosivedrone = Drone.instance()
				if place < place_1:
					player.play("Box High E")
					$Drone.position = Vector2(13*-walking_direktion,-19.5)
					yield(get_tree().create_timer(0.2), "timeout")
					$Drone.position = highdroneE
					yield(player,"animation_finished")
					Explosivedrone.set_position(highdroneE)
					
				elif place > place_1:
					
					player.play("Box Low E")
					$Drone.position = Vector2(8.5*-walking_direktion,-4)
					yield(get_tree().create_timer(0.2), "timeout")
					$Drone.position = lowdroneE
					yield(player,"animation_finished")
					Explosivedrone.set_position(lowdroneE)
				add_child(Explosivedrone)
				
			player.play("Idle")
			player2.play("stehen")
			
		yield(get_tree().create_timer(drone), "timeout")
			
			
func boxhit123():
	pass

func _on_Box_body_entered(body):
	if body.has_method("Ai"):
		var damage = box
		body.takedamage(box,positionpunch)



func Block():
	if death:
		return
	
	if punchposition == 0 or punchposition == 3:
		$AnimationPlayer.play("Block unten")
		player2.play("stehen")
		return
	if punchposition == 1:
		$AnimationPlayer.play("Block")
		player2.play("stehen")
		return
	if punchposition == 2:
		$AnimationPlayer.play("Block oben")
		player2.play("stehen")
		return

func _on_Player_position_changed(new_punchposition):
	punchposition =new_punchposition
	if block:
		boxrandomnummer.randomize()
		var block1 = boxrandomnummer.randf_range(0, 2.0) 

		block = false
	

func _on_Area2D_area_entered(area2D):

	if area2D.has_method("block1"):
		blocking = false

func _on_Area2D_area_exited(_area):
	blocking = true

func handle(amount, damageposition):
	$Timer2.start()#scheiß lösung
	yield ($Timer2,"timeout")
	
	if fliegen_Start:
		return
	
	if death == false:
		
		health -=  amount
		
		#direction.x = +amount/10
		$Particles2D.set_amount(amount*10)
		$Particles2D.set_lifetime(amount/2)
		$Particles2D.process_material.set_param(true,amount *100)
		emit_signal("health_changed_enemy", health)
		grabed = false
		if amount > 0.5:
			
			damagetake = false
			direction.x = amount* walking_direktion
			if damageposition== 0 or damageposition== 3:
				player.play("dam unten")
				player2.play("Schaden unten")
				
				$"Punch 1".set_volume_db((amount-3.5)*1.5 )
				$"Punch 1".play()
				$Damage.set_volume_db((amount-3.5)*0.5 )
			if damageposition == 1:
				player.play("dam")
				player2.play("Schaden mitte")
				$"Punch".set_volume_db((amount-3.5)*1.5 )
				$"Punch".play()
				$Damage.set_volume_db((amount-3.5)*0.5 )

			if damageposition == 2:
				player.play("dam oben")
				player2.play("Schaden mitte")
				$"Punch 1".set_volume_db((amount-3.5)*1.5 )
				$"Punch 1".play()
				$Damage.set_volume_db((amount-3.5)*0.5 )

			yield (get_tree().create_timer(amount/5), "timeout")

			direction.x = 0
			

			$DamageTimer.wait_time = amount
			walkingnumber = amount/10* walking_direktion 

				
				#direction.x = -0.1
		
		block = true
		if crying:
			$AnimationPlayer.play("crying")
			$AnimationPlayer2.play("stehen")
		if (playerposition-position.x) < 100 and (playerposition-position.x) >-100 and !death and !crying:
		 fliegen()
	if health < 0 and death == false:
		
		emit_signal("died")
		death = true
		
		if damageposition== 0 or damageposition== 3 :
			player.play("Death unten")
			player2.play("Deth unten")
		if damageposition == 1:
			player.play("Death")
		if damageposition == 2:
			
			player.play("Death oben")
			player2.play("Deth oben")

		direction.x = 0
	

func blockmade():
	Blockmade = true

func _on_Player_blockingsucessful(_Blockmade):
	blockmade()
	



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


func _on_Level2_position1(player):
	playerposition = player 


func _on_Level2_Healt_lvlStartgegner(helth_ganersart):
	health = helth_ganersart
