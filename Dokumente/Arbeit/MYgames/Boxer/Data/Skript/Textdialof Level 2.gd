extends Node2D


export var dialogPath ="res://Data/Dialogs/Level 2.json"

export(float) var textSpeed = 0.05
var dialog
var answer = false 
var phrasNum = [0,0,2,2,3,4,5,6,9,12,15,18,21,22,23] # Nummber Check Checksize dronerace dronerace intimitate intimitedsize, you win

var time = 30
var gefuhlsmeter = 5
var gegener_Lautsaerke =[-35,-30,-25,-20,-17,-15,-12,-10,-7,-5,-2,0,2,5,7,10,15]

var spacebuttontime = 0
var spacebutton = true

#marg = marging, top,button, t = text, c = color, l = long
var marg_top_t = 8
var marg_button_t = 48
var marg_top_c = 0
var marg_button_c = 40

var marg_top_t_l = -12
var marg_button_t_l = 72
var marg_top_c_l = -18
var marg_button_c_l = 20

var finished = false
var gefuhlr=true
var camera = false
var times_up =false
var cameragegenr = Vector2(200,-60)
var cameraplayer = Vector2(0,0)
#70 ,150
#270,90
var path1 = "res://Data/Save files/datalvl2.json"

const margin_offset = 8
const Winscreen = preload("res://Data/UI/Winscreen.tscn")
const giveupscreen = preload("res://Data/UI/Pilot sam runs away.tscn")
const disqualifiedscreen = preload("res://Data/UI/Normal Joe is disqualified.tscn")

var data_lvl = {}
var output = { }
var Time = { }


onready var textbox = $ancher_text/text
onready var textcolor = $ancher_text/ColorRect
onready var answerbox =$ancher_answer/answer
onready var answercolor =$ancher_answer/ColorRect
onready var ChekButton = $ancher_text/Button3
onready var provokateButton =$ancher_text/Button
onready var intimitateButton =$ancher_text/Button2

var default_data_lvl1 = {
	"player" : {
		"level" : 1,
		"health" : 17
		},
	"gegner" : {
		"crying" : false,
		"skriptreden" : [0,0,2,2,3,4,5,6,9,12,15,18,21,22,23],
		"health" : 10
		},
	"options" : {
		"music_volume" : 0.5,
		"cheat_mode" : false
		},
	"rounds": [1,2,3],
	"Dronerounds":[0,0,0]
}

signal Rounds(rounds)

func _on_Uhr_reden_Time_zero():
	get_tree().change_scene("res://Data/Levels/Level2.tscn")
func _ready():
	load_game()
	$"ancher_text/TextureProgress".value =data_lvl["player"]["health"]
	$"ancher_answer/TextureProgress".value = data_lvl["gegner"]["health"]
	if data_lvl["Dronerounds"][2] == 1 or data_lvl["Dronerounds"][1] == 1:
		$ancher_answer/color1.visible = true
	if data_lvl["Dronerounds"][1] == 0 or data_lvl["Dronerounds"][1] == 4 and data_lvl["Dronerounds"][2] != 1:
		$ancher_answer/color1.visible = true
		
	var rounds =data_lvl["rounds"]
	phrasNum = data_lvl["gegner"]["skriptreden"]
	var length  = rounds.size()
	length = -(length-3)
	emit_signal("Rounds",length)
	$Timer.wait_time = textSpeed
	dialog = getDialog()
	assert(dialog, "Dialog not fougnd")

	
	$AnimationPlayer.play ("idle")
	$AnimationPlayer2.play("gegner idle")
	
	
	if data_lvl["Dronerounds"][1] == 1:
		
		if phrasNum [0] < phrasNum[7]:
			phrasNum[3] = phrasNum[7]+2
			phrasNum[4] = phrasNum[7]+3
			phrasNum[5] = phrasNum[7]+2
			phrasNum[0] = phrasNum[7]
			Button_notvisible()
			nextPhrase()
			phrasNum[0]+= 1
			save_game()
			return
	if data_lvl["Dronerounds"][1]== 2:
		if phrasNum [0] < phrasNum[8]:
			phrasNum[3] = phrasNum[8]+2
			phrasNum[4] = phrasNum[8]+3
			phrasNum[5] = phrasNum[8]+2
			phrasNum[0] = phrasNum[8]
			Button_notvisible()
			nextPhrase()
			phrasNum[0]+= 1
			save_game()
			return
	if data_lvl["Dronerounds"][1]== 3:
		if phrasNum [0] < phrasNum[9]:
			phrasNum[3] = phrasNum[9]+2
			phrasNum[4] = phrasNum[9]+3
			phrasNum[5] = phrasNum[9]+2
			phrasNum[0] = phrasNum[9]
			Button_notvisible()
			nextPhrase()
			phrasNum[0]+= 1
			save_game()
			return
	if data_lvl["Dronerounds"][1]== 4:
		if phrasNum [0] < phrasNum[10]:
			phrasNum[3] = phrasNum[10]+2
			phrasNum[4] = phrasNum[10]+2
			phrasNum[0] = phrasNum[10]
			Button_notvisible()
			nextPhrase()
			phrasNum[0]+= 1
			save_game()
			return
	if data_lvl["Dronerounds"][1]== 5:
		if phrasNum [0] < phrasNum[11]:
			phrasNum[3] = phrasNum[11]+2
			phrasNum[4] = phrasNum[11]+3
			phrasNum[5] = phrasNum[11]+2
			phrasNum[0] = phrasNum[11]
			Button_notvisible()
			nextPhrase()
			phrasNum[0]+= 1
			save_game()
			return
	
	if data_lvl["Dronerounds"][1]== 6:
		if phrasNum [0] < phrasNum[12]:
			phrasNum[3] = phrasNum[12]+2
			phrasNum[4] = phrasNum[12]+3
			phrasNum[5] = phrasNum[12]+2
			phrasNum[0] = phrasNum[12]
			Button_notvisible()
			nextPhrase()
			phrasNum[0]+= 1
			save_game()
			return
	if data_lvl["Dronerounds"][1]== 7:
		if phrasNum [0] < phrasNum[13]:
			phrasNum[3] = phrasNum[13]+2
			phrasNum[4] = phrasNum[13]+3
			phrasNum[5] = phrasNum[13]+2
			phrasNum[0] = phrasNum[13]
			Button_notvisible()
			nextPhrase()
			phrasNum[0]+= 1
			data_lvl["gegner"]["crying"] = true
			save_game()
			return
	if data_lvl["Dronerounds"][1]== 8:
		if phrasNum [0] < phrasNum[14]:
			phrasNum[3] = phrasNum[14]+2
			phrasNum[4] = phrasNum[14]+3
			phrasNum[5] = phrasNum[14]+2
			phrasNum[0] = phrasNum[14]
			Button_notvisible()
			nextPhrase()
			phrasNum[0]+= 1
			save_game()
			return
	Button_visible()

func _process(delta):
	if finished and answerbox.visible_characters != 0 or answer and textbox.visible_characters != 0:
		spacebuttontime += delta
		if spacebuttontime > 3:
			spacevisible()
	if Input.is_action_just_pressed("ui_accept"):
		
		spacebuttontime = 0
		$Sprite2.visible =  false
		spacebutton = true
		if times_up:#when time finished next scene
			changescene()
			return
		if answer:#when the main charakter change 
			nextanswer()
			return
		if finished:
			if camera:
				$AnimationPlayer.play ("camera spieler")
				yield(get_tree().create_timer(0.4), "timeout")
				camera = false
			$AnimationPlayer.play("idle")
			
				
			Text_notvisible()
			
			if phrasNum[3]==phrasNum[4]:
				
				yes_no_buttons()
				return
			Button_visible()
			return
		
		else:
			
			textbox.visible_characters = textbox.text.length()
			if textbox.text.length() < 60:
				var text_size = (textbox.get_font("normal_font").get_string_size(textbox.text).x)
				var color_size = (text_size * textbox.visible_characters/(textbox.text.length()+0.1))
				$Sprite2.position.y = $ancher_text.position.y
				$Sprite2.position.x =$ancher_text.position.x + text_size /2
			
				textcolor.margin_right= color_size + (margin_offset*2) -text_size/2
				textcolor.margin_left =  -text_size/2 -( margin_offset* 3)
			if textbox.text.length() > 60:
				var text_size = (textbox.get_font("normal_font").get_string_size(textbox.text).x)/1.9
				var color_size = (text_size * textbox.visible_characters/textbox.text.length())
				textcolor.margin_right= color_size*2.2 + (margin_offset*2) -text_size/2
				textcolor.margin_left =  -text_size/2 -( margin_offset* 2)
				$Sprite2.position.y = $ancher_text.position.y
				$Sprite2.position.x =$ancher_text.position.x + text_size /2
			if answerbox.visible_characters > 0:
				answerbox.visible_characters = answerbox.text.length()
				if answerbox.text.length() < 60:
					var answer_size =answerbox.get_font("normal_font").get_string_size(answerbox.text).x
					var answer_color_size = answer_size*answerbox.visible_characters/answerbox.text.length()
					answercolor.margin_right= answer_color_size + (margin_offset*2) -answer_size/2
					answercolor.margin_left = -answer_size/2 -( margin_offset* 3)
					$Sprite2.position.y = $ancher_answer.position.y -20
					$Sprite2.position.x =$ancher_answer.position.x + answer_size /2
				if answerbox.text.length() > 60:
					var text_size = (answerbox.get_font("normal_font").get_string_size(answerbox.text).x)/1.9
					var color_size = (text_size * answerbox.visible_characters/answerbox.text.length())
					answercolor.margin_left =  -text_size/2 -( margin_offset* 2)
					answercolor.margin_right= color_size*2.2 + (margin_offset*2) -text_size/2
					$Sprite2.position.y = $ancher_answer.position.y- 20
					$Sprite2.position.x =$ancher_answer.position.x + text_size /2
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

func nextPhrase() -> void:
	
	if phrasNum[0] >= len(dialog):
	
		queue_free()
		return
		
	finished = false

	
	textbox.bbcode_text = dialog[phrasNum[0]]["text"]
	textbox.visible_characters = 0
	var gefuhl =dialog[phrasNum[0]]["info"]
	var art = dialog[phrasNum[0]]["art"]

	if textbox.text.length() == 0:
		finished = false
		camera = true
		nextanswer()

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
			$Sprite2.position.y = $ancher_text.position.y
			$Sprite2.position.x =$ancher_text.position.x + text_size /2
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
			$Sprite2.position.y = $ancher_text.position.y
			$Sprite2.position.x =$ancher_text.position.x + text_size /2
		textbox.visible_characters+= 1
	
		$Timer.start()
		if art != "thinking":
			$reden.play()
			$AnimationPlayer.play("reden")
		if art == "thinking":
			$AnimationPlayer.play("thinking")
			$Thinking.play()
		yield($Timer,"timeout")
	$AnimationPlayer.play("idle")
	answer = true
	finished = false
	camera = true
	return


func nextanswer() -> void:
	
	answer = false
	answerbox.bbcode_text = dialog[phrasNum[0]]["answer"]
	answerbox.visible_characters = 0
	var lenghttext =answerbox.text.length()
	Time = dialog[phrasNum[0]]["lenght"]
	var amount = gegener_Lautsaerke[gefuhlsmeter]
	if lenghttext == 0:
		
		Text_notvisible()
		timertime (Time)
		if phrasNum[0] == phrasNum[4]:
			yes_no_buttons()
			return
		Button_visible()
		return
	$AnimationPlayer.play ("Camera gegner")
	yield(get_tree().create_timer(0.4), "timeout")
	
	
	$"Speech gegner".set_volume_db(amount)
	
	while answerbox.visible_characters < answerbox.text.length():
		

		

		if answerbox.text.length() < 60:
			var text_size =answerbox.get_font("normal_font").get_string_size(answerbox.text).x
			var color_size = text_size*answerbox.visible_characters/answerbox.text.length()
			answercolor.margin_top = marg_top_c
			answercolor.margin_bottom = marg_button_c
			answercolor.margin_right= color_size + (margin_offset*2) -text_size/2
			answercolor.margin_left =  -text_size/2 -( margin_offset* 2)
			answerbox.margin_top= marg_top_t
			answerbox.margin_bottom = marg_button_t
			answerbox.margin_right= text_size/2+ margin_offset
			answerbox.margin_left = -text_size/2 - margin_offset
			$Sprite2.position.y = $ancher_answer.position.y -20
			$Sprite2.position.x =$ancher_answer.position.x + text_size /2
		
		if answerbox.text.length() > 60:
			
			var text_size = (answerbox.get_font("normal_font").get_string_size(answerbox.text).x)/1.9
			var color_size = (text_size * answerbox.visible_characters/answerbox.text.length())
			answercolor.margin_top = marg_top_c_l
			answercolor.margin_bottom = marg_button_c_l
			
			answercolor.margin_left =  -text_size/2 -( margin_offset* 2)
			answerbox.margin_top= marg_top_t_l
			answerbox.margin_bottom = marg_button_t_l
			answerbox.margin_right= text_size/2+ margin_offset
			answerbox.margin_left = -text_size/2 - margin_offset
			if answerbox.visible_characters < answerbox.text.length()/2:
				answercolor.margin_right= color_size*2.2 + (margin_offset*2) -text_size/2
			$Sprite2.position.y = $ancher_answer.position.y -20
			$Sprite2.position.x =$ancher_answer.position.x + text_size /2
		answerbox.visible_characters+= 1
			
		if data_lvl["gegner"]["crying"]== false:
			$AnimationPlayer3.play("Reden")
			$"Speech gegner".play()
		if data_lvl["gegner"]["crying"] :
			$AnimationPlayer2.play("Crying")
			$AnimationPlayer3.play("Crying")
			$Timer.wait_time = 0.2
		
		
		
		
		$Timer.start()
		yield($Timer,"timeout")
	if data_lvl["gegner"]["crying"]:
		get_tree().change_scene("res://Data/Levels/Level2.tscn")
	if data_lvl["Dronerounds"][1] == 6:
		$AnimationPlayer3.play("Fying away")
		yield(get_tree().create_timer(5), "timeout")
		var game_over = giveupscreen.instance()
		data_lvl = default_data_lvl1.duplicate(true)
		save_game()

		yield(get_tree().create_timer(1), "timeout")
		add_child(game_over)
		return
	if phrasNum[0]==phrasNum[5] or phrasNum[0]==phrasNum[6]:
		if data_lvl["Dronerounds"][1] == 2:
			finished = true
			answer = false
			phrasNum[4]+= 1 
			phrasNum[3]-= 1 
			
			timertime(Time)
			$AnimationPlayer2.play("gegner idle")
			$AnimationPlayer3.play("idle")
			return
		$AnimationPlayer2.play("ready")
		$AnimationPlayer3.play("ready")
		yield ($AnimationPlayer2,"animation_finished")
		finished = true
		answer = false
		$AnimationPlayer2.play("drone")
		if data_lvl["Dronerounds"][1] == 1 or  data_lvl["Dronerounds"][1] == 3:
			get_tree().change_scene("res://Data/Levels/Dronelevel1.tscn")
			return
		
		get_tree().change_scene("res://Data/Levels/Dronelevel.tscn")
		
		return
	
	$AnimationPlayer2.play("gegner idle")
	$AnimationPlayer3.play("idle")
	finished = true
	answer = false
	timertime (Time)
	return

func Timerstime():
	#var rounds = data_lvl["rounds"]##hier sollte der Uhr effekt kommen das wenn man redet die Uhr herunterzahlt und nicht so wie jetz einfach zum ergebniss springt
		pass

func timertime(Time: float) -> int:
	time -= Time
	var mils = fmod(time,1)*100
	var secs = fmod(time,60)
	var rounds =data_lvl["rounds"]
	var length  = rounds.size()
	length = -(length-3)
	
	var time_passed ="%d %02d:%02d" %[length, secs ,mils]
	$Uhr.text = time_passed
	if time <= 0:##scene change
		times_up = true
	return 1

func load_game():
	var file = File.new()
	
	if  not file.file_exists(path1) :
		return
	
	file.open(path1, file.READ)
	
	var text = file.get_as_text()
	
	data_lvl = parse_json(text)
	
	file.close()

func save_game():
	var file
	
	file = File.new()
	
	file.open(path1, File.WRITE)
	
	file.store_line(to_json(data_lvl))
	
	file.close()

func Button_notvisible():
	$ancher_text/Button4.visible = !visible
	ChekButton.visible = !visible
	provokateButton.visible =!visible
	intimitateButton.visible= !visible

func yes_no_buttons():
	$ancher_text/Button5.visible = visible
	$ancher_text/Button6.visible = visible
	
func yes_no_notvisible():
	$ancher_text/Button5.visible = !visible
	$ancher_text/Button6.visible = !visible

func Button_visible():
	$ancher_text/Button4.visible =  visible
	if phrasNum [1] < phrasNum [2]:
		ChekButton.visible = visible
	if phrasNum [3] < phrasNum [4]:
		provokateButton.visible =visible

func Text_notvisible(): 
	answerbox.visible_characters = 0
	textbox.visible_characters = 0
	textcolor.margin_right=0
	textcolor.margin_left = 0
	textbox.margin_right=0
	textbox.margin_left = 0
	answercolor.margin_right=0
	answercolor.margin_left = 0
	answerbox.margin_right =0
	answerbox.margin_left = 0

func changescene():
	
	save_game()
	get_tree().change_scene("res://Data/Levels/Level2.tscn")

func _on_Button3_button_down():
	phrasNum[0] = phrasNum[1]
	Button_notvisible()
	
	nextPhrase()
	if phrasNum[1] < phrasNum[2]:
		phrasNum[1]= phrasNum[1] +1
		return

func _on_Button2_button_down():
	phrasNum[0] =phrasNum[5]
	Button_notvisible()
	if gefuhlsmeter == 3:
		phrasNum[0] = 22
	nextPhrase()
	if phrasNum[5] < phrasNum[6]:
		phrasNum[5] = phrasNum[5] +1
		return

func _on_Button_button_down():
	phrasNum[0] = phrasNum[3]
	Button_notvisible()
	nextPhrase()
	if phrasNum[3] < phrasNum[4]:
		phrasNum[3]= phrasNum[3] +1
		return

func _on_Button4_button_down():
	timertime(30)
	_on_Uhr_reden_Time_zero()

func _on_Button6_button_down():

	phrasNum[0] = phrasNum[6]
	yes_no_notvisible()
	nextPhrase()
	data_lvl["Dronerounds"][0]=0
	save_game()
	
	phrasNum[3]= phrasNum[3] +3


func _on_Button5_button_down():
	data_lvl["Dronerounds"][0]=1
	save_game()
	phrasNum[0] = phrasNum[5]
	yes_no_notvisible()
	nextPhrase()
	phrasNum[3]= phrasNum[3] +2

func spacevisible():
	if spacebutton:
		spacebutton = false
		$Sprite2.visible = visible
		
		$"Sprite2/AnimationPlayer".play("space")
