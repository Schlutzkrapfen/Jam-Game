extends Node2D
var rounds = -1

var hit = false

export var speed = 81

export(float) var textSpeed = 0.2
var dialog
var answer = false 
var phrasNum = [4,5]
var tutorialFinisched = false

var data_lvl={}
var output = {}
var finished = false

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
var start = false
var start1 = true
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
	
	load_game()
	dialog = getDialog()
	nextPhrase()
	
	
func _process(delta):
	if finished and start:
		start = false
		
		
		
		yield(get_tree().create_timer(3), "timeout")
		Text_notvisible()
		if start1:
			time_now = true
			start1= false
		
		
	if time_now :
		
		time  -= delta
		var secs = fmod(time,60)
		var sexs = "%d" %[secs]
		$CanvasLayer/Label.text = sexs
		$CanvasLayer/AnimationPlayer.play("Uhr")
		
		yield(get_tree().create_timer(4), "timeout")
		time_now = false
		$StaticBody2D4.set_collision_layer(0)
		tutorialFinisched= true
		$Path2D2/PathFollow2D/KinematicBody2D.start = true
	if Input.is_action_just_pressed("ui_accept") :
		
		if finished:

			
			Text_notvisible()
			if start1:
				time_now = true
				start1 = false
			yield(get_tree().create_timer(4), "timeout")
			$StaticBody2D4.set_collision_layer(0)
			tutorialFinisched= true

			$Path2D2/PathFollow2D/KinematicBody2D.start = true
			time_now = false
			return
			
		else:
			textbox.visible_characters = textbox.text.length()
			if textbox.text.length() < 60:
				var text_size = (textbox.get_font("normal_font").get_string_size(textbox.text).x)
				var color_size = (text_size * textbox.visible_characters/(textbox.text.length()+0.1))
			
			
				textcolor.margin_right= color_size + (margin_offset*2) -text_size/2
				textcolor.margin_left =  -text_size/2 -( margin_offset* 3)
			if textbox.text.length() > 60:
				var text_size = (textbox.get_font("normal_font").get_string_size(textbox.text).x)/1.9
				var color_size = (text_size * textbox.visible_characters/textbox.text.length())
				textcolor.margin_right= color_size*2.2 + (margin_offset*2) -text_size/2
				textcolor.margin_left =  -text_size/2 -( margin_offset* 2)
			
		
		
		
func _physics_process(delta):
	
	if tutorialFinisched  and !time_now:
		$Path2D2/PathFollow2D.offset = $Path2D2/PathFollow2D.offset +delta * speed

	if $Path2D2/PathFollow2D.unit_offset ==1 :
		$Path2D2/PathFollow2D.unit_offset =0
		
		rounds +=1
		if rounds == 2:
			data_lvl["Dronerounds"][1] = 8
			save_game()
			get_tree().change_scene("res://Data/Levels/Level2,5.tscn")
			



func nextPhrase() -> void:
	
	if phrasNum[0] >= len(dialog):
	
		queue_free()
		return
		
	finished = false

	
	textbox.bbcode_text = dialog[phrasNum[0]]["text"]
	textbox.visible_characters = 0

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
				
		textbox.visible_characters+= 1
	
		

	yield(get_tree().create_timer(textSpeed), "timeout")
	start = true
	finished = true
	phrasNum[0] +=1 
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



func _on_KinematicBody2D_hit(healt):
	speed = 10
	hit = true
	nextPhrase()
	yield(get_tree().create_timer(1.5), "timeout")
	hit = false
	speed = 81
	if healt  <= 0:
		dronedead = true
		speed = 0
		data_lvl["Dronerounds"][1] = 7
		save_game()
		get_tree().change_scene("res://Data/Levels/Level2,5.tscn")
		

func _on_KinematicBody2D_boost():
	speed = speed * 2
	yield(get_tree().create_timer(1), "timeout")
	if !hit:
		speed =81
	
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

func Text_notvisible(): 
	textbox.visible_characters = 0
	textcolor.margin_right=0
	textcolor.margin_left = 0
	textbox.margin_right=0
	textbox.margin_left = 0






func _on_KinematicBody2D2_Roundsover(rounds):
	data_lvl["Dronerounds"][1]=6
	save_game()
	
	get_tree().change_scene("res://Data/Levels/Level2,5.tscn")
