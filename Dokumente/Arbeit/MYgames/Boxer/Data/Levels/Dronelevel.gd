extends Node2D
var rounds = -1
var rounds1 = -1
var hit = false
var hit1= false
export var speed = 100
export var speed1 = 100
export(float) var textSpeed = 0.8
var dialog
var answer = false 
var phrasNum = [0,4]
var tutorialFinisched = false

var leftButtonpressed = false
var rightButtonpressed = false
var upbuttonpressed = false
var downbuttonpressed = false
var buttonpressed = true
var shift = true


var node_var = true
var node_var1 = true

var data_lvl={}
var output = {}
var finished = true

var spacebuttontime = 0
var spacebutton = true

const margin_offset = 8
var marg_top_t = 8
var marg_button_t = 48
var marg_top_c = 0
var marg_button_c = 40

var marg_top_t_l = -12
var marg_button_t_l = 72
var marg_top_c_l = -18
var marg_button_c_l = 20

var time = 4
var time_now = false
var drone1dead = false
var dronedead = false
onready var textbox = $CanvasLayer/RichTextLabel
onready var textcolor=$CanvasLayer/ColorRect

var path1 = "res://Data/Save files/datalvl2.json"
export var dialogPath ="res://Data/Dialogs/Dronlevel.json"

func _ready():
	$CanvasLayer.offset= get_viewport_rect().size /2
	$Path2D2/PathFollow2D/KinematicBody2D/AnimationPlayer.play("standstill")
	$Path2D/PathFollow2D/KinematicBody2D/AnimationPlayer.play("standstill")
	load_game()

	dialog = getDialog()
	
	if data_lvl["Dronerounds"][0]==0:# start for tutorial
		$CanvasLayer/Sprite.visible = true
		$CanvasLayer/Sprite2.visible = true
		$CanvasLayer/Sprite3.visible = true
		$CanvasLayer/Sprite5.visible = true
		nextPhrase()
		return
	if data_lvl["Dronerounds"][0]==1:
		phrasNum[0]= phrasNum[1]
	if finished:
			
		if  data_lvl["Dronerounds"][0]==1:
			Text_notvisible()
			time_now = true
				
			yield(get_tree().create_timer(4), "timeout")
			$StaticBody2D4.set_collision_layer(0)
			tutorialFinisched= true

			$Path2D/PathFollow2D/KinematicBody2D.start = true
			$Path2D2/PathFollow2D/KinematicBody2D.start = true
			time_now = false
			return
	
	time_now = true
	yield(get_tree().create_timer(4), "timeout")
	
	$StaticBody2D4.set_collision_layer(0)
	tutorialFinisched= true
	time_now = false
func _process(delta):
	if time_now:
		time  -= delta
		var secs = fmod(time,60)
		var sexs = "%d" %[secs]
		$CanvasLayer/Label.text = sexs
		$CanvasLayer/AnimationPlayer.play("Uhr")
	if tutorialFinisched == false:
		if phrasNum[0] == 1:
			
			if Input.is_action_just_pressed("Move_left"):
				$CanvasLayer/Sprite4/AnimationPlayer.play("Button Press A")
				leftButtonpressed = true
				
			
			if Input.is_action_just_pressed("Move_right"):
				$CanvasLayer/Sprite4/AnimationPlayer.play("Button Press D")
				rightButtonpressed = true
			if Input.is_action_just_pressed("down(drone)"):
				$CanvasLayer/Sprite4/AnimationPlayer.play("Button Press S")
				downbuttonpressed = true
			if Input.is_action_just_pressed("up(drowne)"):
				$CanvasLayer/Sprite4/AnimationPlayer.play("Button Press W")
				upbuttonpressed = true
			if upbuttonpressed and rightButtonpressed and leftButtonpressed and downbuttonpressed and buttonpressed:# need to use another verible that nextphrase doesent plyay more than ones
					buttonpressed = false
					
					yield(get_tree().create_timer(1), "timeout")
					$CanvasLayer/Sprite.visible = false
					$CanvasLayer/Sprite2.visible = false
					$CanvasLayer/Sprite3.visible = false
					$CanvasLayer/Sprite5.visible = false
					nextPhrase()

		if phrasNum[0] == 2: 
			if shift:
				$CanvasLayer/Sprite7.visible = visible
				shift = false
			
			if Input.is_action_just_pressed("Hit") and $droneplayer.rocket1:
				$CanvasLayer/Sprite4/AnimationPlayer.play("Button Press mouse 1")
				yield(get_tree().create_timer(1), "timeout")
				$CanvasLayer/Sprite7.visible = false
				shift = true
				nextPhrase()
		if phrasNum[0] == 3 :
			if shift:
				$CanvasLayer/Sprite6.visible = visible
				shift = false
			if Input.is_action_just_pressed("roll") and $droneplayer.boost_now:
				$CanvasLayer/Sprite4/AnimationPlayer.play("Button Press Shift")
				yield(get_tree().create_timer(1), "timeout")
				$CanvasLayer/Sprite6.visible = false
				shift = true
				nextPhrase()
		if phrasNum[0] == 4 :
			if shift:
				$CanvasLayer/Sprite8.visible = visible
				shift = false
			if Input.is_action_just_pressed("Block") and $droneplayer.shild:
				$CanvasLayer/Sprite4/AnimationPlayer.play("Button Press Mouse 2")
				yield(get_tree().create_timer(1), "timeout")
				$CanvasLayer/Sprite8.visible = false
				Text_notvisible()
				time_now = true
				
				yield(get_tree().create_timer(4), "timeout")
				$StaticBody2D4.set_collision_layer(0)
				tutorialFinisched= true
				
				node_var1 = get_node_or_null("Path2D/PathFollow2D/KinematicBody2D")
				if node_var1 :
					
					$Path2D/PathFollow2D/KinematicBody2D.start = true
				node_var = get_node_or_null("Path2D2/PathFollow2D/KinematicBody2D")
				if node_var :
					$Path2D2/PathFollow2D/KinematicBody2D.start = true
				time_now = false
				return
	if Input.is_action_just_pressed("ui_accept") :
		spacebuttontime = 0
		$"CanvasLayer/Sprite4".visible =  false
		spacebutton = true
		if finished and tutorialFinisched:
			
			if phrasNum[0] ==phrasNum[1] or data_lvl["Dronerounds"][0]==1:
				Text_notvisible()
				time_now = true
				
				yield(get_tree().create_timer(4), "timeout")
				$StaticBody2D4.set_collision_layer(0)
				tutorialFinisched= true
				
				node_var1 = get_node_or_null("Path2D/PathFollow2D/KinematicBody2D")
				if node_var1 :
					
					$Path2D/PathFollow2D/KinematicBody2D.start = true
				node_var = get_node_or_null("Path2D2/PathFollow2D/KinematicBody2D")
				if node_var :
					$Path2D2/PathFollow2D/KinematicBody2D.start = true
				time_now = false
				return
			nextPhrase()
			return
		
		else:
			textbox.visible_characters = textbox.text.length()
			if textbox.text.length() < 60:
				var text_size = (textbox.get_font("normal_font").get_string_size(textbox.text).x)
				var color_size = (text_size * textbox.visible_characters/(textbox.text.length()+0.1))
				$"CanvasLayer/Sprite4".position.y = $"CanvasLayer/ColorRect".rect_position.y -2
				$"CanvasLayer/Sprite4".position.x =$"CanvasLayer/ColorRect".rect_position.x + text_size +5 
			
				textcolor.margin_right= color_size + (margin_offset*2) -text_size/2
				textcolor.margin_left =  -text_size/2 -( margin_offset* 3)
			if textbox.text.length() > 60:
				var text_size = (textbox.get_font("normal_font").get_string_size(textbox.text).x)/1.9
				var color_size = (text_size * textbox.visible_characters/textbox.text.length())
				textcolor.margin_right= color_size*2.2 + (margin_offset*2) -text_size/2
				textcolor.margin_left =  -text_size/2 -( margin_offset* 2)
				$"CanvasLayer/Sprite4".position.y = $"CanvasLayer/ColorRect".rect_position.y -2 
				$"CanvasLayer/Sprite4".position.x =$"CanvasLayer/ColorRect".rect_position.x + text_size + 5
			

func _physics_process(delta):
	
	if tutorialFinisched and data_lvl["Dronerounds"][0]==0 and !time_now or tutorialFinisched and data_lvl["Dronerounds"][0]==1 and !time_now:
		$Path2D2/PathFollow2D.unit_offset = $Path2D2/PathFollow2D.unit_offset  +delta/2372.2* speed
		$Path2D/PathFollow2D.unit_offset = $Path2D/PathFollow2D.unit_offset +delta/2382.78 * speed1
	if $Path2D2/PathFollow2D.unit_offset ==1 :
		$Path2D2/PathFollow2D.unit_offset =0
		
		rounds +=1
		if rounds == 2:
			
			data_lvl["Dronerounds"][1] = 4
			save_game()
			get_tree().change_scene("res://Data/Levels/Level2,5.tscn")
	
	if $Path2D/PathFollow2D.unit_offset ==1 :
		$Path2D/PathFollow2D.unit_offset =0
		rounds1 +=1
		if rounds1 == 2:
			data_lvl["Dronerounds"][1] = 4
			save_game()
			get_tree().change_scene("res://Data/Levels/Level2,5.tscn")
			return


func nextPhrase() -> void:
	
	
	
	if phrasNum[0] >= len(dialog):
	
		queue_free()
		return
		
	finished = false
	
	
	textbox.bbcode_text = dialog[phrasNum[0]]["text"]
	textbox.visible_characters = 0
	phrasNum[0] +=1 
	if textbox.text.length() == 0:
		finished = true
		nextPhrase()

		return

	while textbox.visible_characters < textbox.text.length():
		if textbox.text.length() < 60:
			var text_size = (textbox.get_font("normal_font").get_string_size(textbox.text).x)
			var color_size = (text_size * textbox.visible_characters/textbox.text.length())
			textcolor.margin_top = marg_top_c
			textcolor.margin_bottom = marg_button_c
			textcolor.margin_right= color_size + (margin_offset*2) -text_size/2
			textcolor.margin_left =  -text_size/2 -( margin_offset* 2)
			textbox.margin_top= marg_top_t
			textbox.margin_bottom = marg_button_t
			textbox.margin_right= text_size/2+ margin_offset
			textbox.margin_left = -text_size/2 - margin_offset
			$"CanvasLayer/Sprite4".position.y = $"CanvasLayer/ColorRect".rect_position.y + -2 
			$"CanvasLayer/Sprite4".position.x =$"CanvasLayer/ColorRect".rect_position.x + text_size +5
		if textbox.text.length() > 60:
			
			var text_size = (textbox.get_font("normal_font").get_string_size(textbox.text).x)/1.9
			var color_size = (text_size * textbox.visible_characters/textbox.text.length())
			textcolor.margin_top = marg_top_c_l
			textcolor.margin_bottom = marg_button_c_l
			
			textcolor.margin_left =  -text_size/2 -( margin_offset* 2)
			textbox.margin_top= marg_top_t_l
			textbox.margin_bottom = marg_button_t_l
			textbox.margin_right= text_size/2+ margin_offset
			textbox.margin_left = -text_size/2 - margin_offset
			if textbox.visible_characters < textbox.text.length()/2:
				textcolor.margin_right= color_size*2.2 + (margin_offset*2) -text_size/2
			$"CanvasLayer/Sprite4".position.y = $"CanvasLayer/ColorRect".rect_position.y -2 
			$"CanvasLayer/Sprite4".position.x =$"CanvasLayer/ColorRect".rect_position.x + text_size +5
				
		textbox.visible_characters+= 1
	
		

	yield(get_tree().create_timer(textSpeed), "timeout")

	finished = true
	
	return



func save_game():
	var file
	
	file = File.new()
	
	file.open(path1, File.WRITE)
	
	file.store_line(to_json(data_lvl))
	
	file.close()

var default_data_lvl2 = {
	"player" : {
		"level" : 1,
		"health" : 20
		},
	"gegner" : {
		"crying" : false,
		"skriptreden" : [0,0,2,2,3,4,5,6,9,12,15,18,21,22,23],
		"health" : 25
		},
	"options" : {
		"music_volume" : 0.5,
		"cheat_mode" : false
		},
	"rounds": [1,2,3],
	"Dronerounds":[0,0,0]
	}

func reset_data():
	# Reset to defaults
	data_lvl = default_data_lvl2.duplicate(true)
	save_game()


func load_game():
	var file = File.new()
	
	if  not file.file_exists(path1) :
		reset_data()
		return
	
	file.open(path1, file.READ)
	
	var text = file.get_as_text()
	
	data_lvl = parse_json(text)
	
	file.close()

func dronearedead():
	
	if dronedead and drone1dead and !tutorialFinisched:
		
		data_lvl["Dronerounds"][1] = 2
		save_game()
		get_tree().change_scene("res://Data/Levels/Level2,5.tscn")
		return
	if dronedead and drone1dead:
		
		data_lvl["Dronerounds"][1] = 3
		save_game()
		get_tree().change_scene("res://Data/Levels/Level2,5.tscn")

func _on_KinematicBody2D_hit(healt):
	speed = 10
	hit = true
	yield(get_tree().create_timer(0.5), "timeout")
	hit = false
	speed = 100
	if healt  <= 0:
		dronedead = true
		speed = 0
		dronearedead()
		

func _on_KinematicBody2D_boost():
	speed = speed * 2
	yield(get_tree().create_timer(1), "timeout")
	if !hit:
		speed =100
	
func getDialog()-> Array:
	var file =File.new()
	assert(file.file_exists(dialogPath),"file not there")
	file.open(dialogPath, File.READ)
	var json =file.get_as_text()
	
	output = parse_json(json)
	
	if typeof(output) == TYPE_ARRAY:
		return output
	else:
		return []

func _on_droneplayer_Roundsover():
	
	data_lvl["Dronerounds"][1]=1
	save_game()
	
	get_tree().change_scene("res://Data/Levels/Level2,5.tscn")
	
func Text_notvisible(): 
	textbox.visible_characters = 0
	textcolor.margin_right=0
	textcolor.margin_left = 0
	textbox.margin_right=0
	textbox.margin_left = 0


func _on_KinematicBody2D_boost1():
	speed1 = speed1* 2

	yield(get_tree().create_timer(1), "timeout")
	if !hit1:
		speed1 =100



func _on_KinematicBody2D_hit1(healt):
	speed1 = 10
	hit1 = true
	yield(get_tree().create_timer(0.5), "timeout")
	hit1 = false
	speed1 = 100
	
	if healt <= 0:
		drone1dead = true
		data_lvl["Dronerounds"][2]=1
		save_game()
		speed1 = 0
		dronearedead()


func _on_droneplayer_dead():
	data_lvl["Dronerounds"][1]=5
	save_game()
	get_tree().change_scene("res://Data/Levels/Level2,5.tscn")
	return
	
func spacevisible():
	if spacebutton:
		spacebutton = false
		$"CanvasLayer/Sprite4".visible = visible
		
		$CanvasLayer/Sprite4/AnimationPlayer.play("space")

