extends KinematicBody2D 
class_name Player
export var  speed = 200#walkingspeed
export var healt = 100


var Healtupgrade =1
var ammoupgrade = 1
var damage_up =1

var velocity = Vector2()
var Weapon_ready = [0,0,0]#pistol,uzi,shotgun # whit this array you can see an wich place wich weapon is
var bullet = preload("res://Scenes/Player/Bullet.tscn")
var pistol = preload("res://Scenes/Player/Pistol.tscn")
var shotgun = preload("res://Scenes/Player/Shotgun.tscn")
var Uzi = preload("res://Scenes/Player/Uzi.tscn")
#class_name Weapon
onready var current_weapon: Weapon = $Weaponmaster/Flashlight
var weapon_nummber = 0

var weapons: Array = []

func damage(damage):
	healt -= damage
	$UI/TextureProgress.value = healt
	if healt <=0:
		queue_free()
func _ready() :
	$AnimatedSprite.play("Idle")
	weapons = $Weaponmaster.get_children()
	for weapon in weapons:
		weapon.hide()
		weapon.UI_hide()
	current_weapon.show()
	current_weapon.UI_show()
	$UI/RichTextLabel.text = String (current_weapon.clip)+ "|" +String (current_weapon.reserve_ammo)
	$UI/RichTextLabel.set_position(get_viewport_rect().size - Vector2(70,25))
#	$UI/TextureProgress.set_position(Vector2(get_viewport_rect().size.x -105,10))
	
	
func get_current_weapon() -> Weapon:
	return current_weapon
	
func switch_weapon(weapon: Weapon):
	if weapon == current_weapon:
		return
	current_weapon.hide()
	weapon.show()
	current_weapon = weapon
	$UI/RichTextLabel.text = String (current_weapon.clip) +"|" +  String (current_weapon.reserve_ammo)
func _physics_process(_delta):
	if  Input.is_action_pressed("fire") and !current_weapon.semi_auto:
		current_weapon.shoot(rotation)
		$UI/RichTextLabel.text = String (current_weapon.clip) +"|" +  String (current_weapon.reserve_ammo)
	elif Input.is_action_just_pressed("fire") :#and current_weapon.semi_auto:
		current_weapon.shoot(rotation)
		  
		$UI/RichTextLabel.text = String (current_weapon.clip)+"|" +  String (current_weapon.reserve_ammo)
	look_at(get_global_mouse_position())#  player look to the mousposition

	velocity = Vector2()# simple movmentskript
	
	if Input.is_action_pressed("down"):# 
		velocity.y += speed
		if rotation_degrees >= 45 and rotation_degrees < 135:
			$AnimatedSprite.play("run")
		if rotation_degrees >= 135 and rotation_degrees < 180 or rotation_degrees <= -135 and rotation_degrees > -180:# I dont understand why i need to do it this way
			$AnimatedSprite.play("Strafe_right")
		if rotation_degrees >= -135 and rotation_degrees < -45:
			$AnimatedSprite.play("walk")
		if rotation_degrees >= -45 and rotation_degrees <45:
			$AnimatedSprite.play("Strafe_left")

	if Input.is_action_pressed("left"):
		velocity.x -= speed
		if rotation_degrees >= 45 and rotation_degrees < 135:
			$AnimatedSprite.play("Strafe_left")
		if rotation_degrees >= 135 and rotation_degrees < 180 or rotation_degrees <= -135 and rotation_degrees > -180:# I dont understand why i need to do it this way
			$AnimatedSprite.play("run")
		if rotation_degrees >= -135 and rotation_degrees < -45:
			$AnimatedSprite.play("Strafe_right")
		if rotation_degrees >= -45 and rotation_degrees <45:
			$AnimatedSprite.play("walk")
	if Input.is_action_pressed("right"):
		velocity.x += speed
		if rotation_degrees >= 45 and rotation_degrees < 135:
			$AnimatedSprite.play("Strafe_right")
		if rotation_degrees >= 135 and rotation_degrees < 180 or rotation_degrees <= -135 and rotation_degrees > -180:# I dont understand why i need to do it this way
			$AnimatedSprite.play("walk")
		if rotation_degrees >= -135 and rotation_degrees < -45:
			$AnimatedSprite.play("Strafe_left")
		if rotation_degrees >= -45 and rotation_degrees <45:
			$AnimatedSprite.play("run")
	if Input.is_action_pressed("up"):
		velocity.y -= speed
		if rotation_degrees >= 45 and rotation_degrees < 135:
			$AnimatedSprite.play("walk")
		if rotation_degrees >= 135 and rotation_degrees < 180 or rotation_degrees <= -135 and rotation_degrees > -180:# I dont understand why i need to do it this way
			$AnimatedSprite.play("Strafe_left")
		if rotation_degrees >= -135 and rotation_degrees < -45:
			$AnimatedSprite.play("run")
		if rotation_degrees >= -45 and rotation_degrees <45:
			$AnimatedSprite.play("Strafe_right")
	move_and_slide(velocity)
	
	if velocity == Vector2(0,0):
		if current_weapon.running == true:
			current_weapon.move()
			$AnimatedSprite.play("Idle")
		current_weapon.running = false
	elif velocity != Vector2(0,0):
		if current_weapon.running == false:
			current_weapon.move()
			
		current_weapon.running = true
	
func _unhandled_input(event: InputEvent) -> void:
	
	if event.is_action_released("reload"):
		current_weapon.start_reload()
		
	elif event.is_action_released("weapon+"):
		weapon_nummber += 1
		if weapon_nummber == weapons.size():
			weapon_nummber = 0
		switch_weapon(weapons[weapon_nummber])
	elif event.is_action_released("weapon-"):
		weapon_nummber -= 1
		if weapon_nummber < 0:
			weapon_nummber = weapons.size() -1
		switch_weapon(weapons[weapon_nummber])
	elif event.is_action_released("weapon 1"):
		if 0 <= weapons.size() -1:
			switch_weapon(weapons[0])
	elif event.is_action_released("weapon 2"):
		if 1 <= weapons.size() -1:
			switch_weapon(weapons[1])
	elif event.is_action_released("weapon 3"):
		if 2 <= weapons.size() -1:
			switch_weapon(weapons[2])
	elif event.is_action_released("weapon 4"):
		if 3 <= weapons.size() -1:
			switch_weapon(weapons[3])
	for weapon in weapons:
		weapon.hide()
		weapon.UI_hide()
	current_weapon.show()
	current_weapon.UI_show()

func _pick_up(weapon,ammo):
	if weapon == "Shotgun" and Weapon_ready[2] == 0:
		var Weapon_instance = shotgun.instance()
		$Weaponmaster.add_child(Weapon_instance)
		weapons = $Weaponmaster.get_children()
		Weapon_ready[2] = weapons.size() -1
		switch_weapon(weapons[weapons.size() -1])
	elif weapon == "Shotgun" and Weapon_ready[2] != 0 or weapon == "Shotgun_ammo":
		weapons[Weapon_ready[2]].add_clip(ammo)
		$UI/RichTextLabel.text = String (current_weapon.clip) +"|" +  String (current_weapon.reserve_ammo)
	elif weapon == "Uzi" and Weapon_ready[1] == 0:
		var Weapon_instance = Uzi.instance()
		$Weaponmaster.add_child(Weapon_instance)
		weapons = $Weaponmaster.get_children()
		Weapon_ready[1] = weapons.size() -1
		switch_weapon(weapons[weapons.size() -1])
	elif weapon == "Uzi" and Weapon_ready[1] != 0 or weapon == "Uzi_ammo":
		weapons[Weapon_ready[1]].add_clip(ammo)
		$UI/RichTextLabel.text = String (current_weapon.clip) +"|" +  String (current_weapon.reserve_ammo)
	elif weapon == "Pistol" and Weapon_ready[0] == 0:
		var Weapon_instance = pistol.instance()
		$Weaponmaster.add_child(Weapon_instance)
		weapons = $Weaponmaster.get_children()
		Weapon_ready[0] = weapons.size() -1
		switch_weapon(weapons[weapons.size() -1])
	elif weapon == "Pistol" and Weapon_ready[0] != 0 or weapon == "Pistol_ammo":
		weapons[Weapon_ready[0]].add_clip(ammo)
		$UI/RichTextLabel.text = String (current_weapon.clip) +"|" +  String (current_weapon.reserve_ammo)

func _process(delta):
	
	if Input.is_action_pressed("Esc"):
		$UI/Pause.show()
		get_tree().paused = true


func _on_Pause_menu_closed():
	while (Game.health_up >Healtupgrade):
		healt += 10
		Healtupgrade += 1
	while (Game.ammo_up > ammoupgrade):
		for weapon in weapons:
			weapon.clip_size += 1
		ammoupgrade += 1
	while (Game.damage_up > damage_up):
		for weapon in weapons:
			weapon.damage += 0.1
		damage_up += 1
