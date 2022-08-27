extends Node2D
class_name Weapon
# don"t change any values in skript !!!
export var light = false
export var bullet_speed = 2000 # speed of the bullet
export var single_reload = false
export var burst = false
export var burstspeed = 0.1 # how fast tje bullets will fire in the burst mode
export var semi_auto = true # if you need to click or hold to fire
export var bulletspread:float = 0# don"t overdue it
export var bullets:float = 1# how many bullets there are per shot or burst
export var clip_size = 10 
export var reserve_ammo = 100 
export var damage:float =1 
var bulletspreadgenerator = RandomNumberGenerator.new()
var clip = 10
var running = false

var bullet = preload("res://Scenes/Player/Bullet.tscn")# fire skript


func _ready():
	$CanvasLayer/TextureRect.set_position(get_viewport_rect().size - Vector2(110,70))
	clip = clip_size
	
	if running:
		$AnimatedSprite.play("move")
		return
	$AnimatedSprite.play("idle")
	
func shoot(r):
	if Input.is_action_pressed("fire") and $firespeed.is_stopped()and clip > 0 and $ReloadTime.is_stopped():
		$firespeed.start()
		$AnimatedSprite.play("fire")
		$Sound_shoot.play()
		clip -= 1
		for number in range(bullets,0,-1):
			var bullet_instance = bullet.instance()
			bullet_instance.position = $end_of_weapon.get_global_position() 
			bullet_instance.damage = damage
			bulletspreadgenerator.randomize()
			var random = bulletspreadgenerator.randf_range(-bulletspread,bulletspread)
			bullet_instance.rotation = r + random 
			bullet_instance.apply_impulse(Vector2(),Vector2(bullet_speed,0).rotated(r+ random))
			get_tree().get_root().add_child(bullet_instance)
			if burst:
				
				yield(get_tree().create_timer(burstspeed),"timeout")
				
				
	if Input.is_action_pressed("fire") and light:

		if $Light2D.enabled == false:
			$Light2D.enabled = true
			return
		$Light2D.enabled = false
	yield($AnimatedSprite,"animation_finished")
	if running:
		$AnimatedSprite.play("move")
		return
	$AnimatedSprite.play("idle")

		
func start_reload():
	$ReloadTime.start()
	if reserve_ammo == 0 or clip == clip_size:
		return
	yield($ReloadTime,"timeout")
	$Sound_reload.play()
	$AnimatedSprite.play("reload")
	if reserve_ammo +clip < clip_size:
		clip = reserve_ammo +clip
		reserve_ammo = 0
		$"../../UI/RichTextLabel".text = String(clip)+"|" +  String (reserve_ammo)
		yield($AnimatedSprite,"animation_finished")
		if running:
			$AnimatedSprite.play("move")
			return
		$AnimatedSprite.play("idle")
		return
	reserve_ammo -= clip_size - clip 
	clip = clip_size
	
	yield($AnimatedSprite,"animation_finished")
	
	$"../../UI/RichTextLabel".text = String(clip)+"|" +  String (reserve_ammo)
	if running:
		$AnimatedSprite.play("move")
		return
	$AnimatedSprite.play("idle")
func UI_hide():
	$CanvasLayer/TextureRect.visible = false
func UI_show():
	$CanvasLayer/TextureRect.visible = true
func add_clip(ammo):
	reserve_ammo += ammo
func move():
	if running:
		$AnimatedSprite.play("move")
		return
	$AnimatedSprite.play("idle")
func make_reload_sound():
	$Sound_reload.play()
