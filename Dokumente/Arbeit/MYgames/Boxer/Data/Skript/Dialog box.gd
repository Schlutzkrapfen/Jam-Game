extends Node2D
export var dialogPath ="res://Data/Dialogs/Level 1.json"
export(float) var textSpeed = 0.05
var dialog
var answer = false 
var phrasNum = [0,0,2,2,4,12,21] # Nummber Check Checksize dronerace droneraceend intimitate intimitedsize

var time = 30
var gefuhlsmeter = 5
var gegener_Lautsaerke =[-35,-30,-25,-20,-17,-15,-12,-10,-7,-5,-2,0,2,5,7,10,15]

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
var path1 = "res://Data/Save files/datalvl1.json"

const margin_offset = 8
const Winscreen = preload("res://Data/UI/Winscreen.tscn")
const giveupscreen = preload("res://Data/UI/joe gives up.tscn")
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

signal Rounds(rounds)

func _on_Uhr_reden_Time_zero():
	get_tree().change_scene("res://Data/Levels/Level1.tscn")
func _ready():
	load_game()
	var rounds =data_lvl["rounds"]
	phrasNum = data_lvl["gegner"]["skriptreden"]
	var length  = rounds.size()
	length = -(length-3)
	emit_signal("Rounds",length)
	$Timer.wait_time = textSpeed
	dialog = getDialog()
	assert(dialog, "Dialog not fougnd")
	gefuhlsmeter =data_lvl["gegner"]["gefühlsmeter"]
	changemeter(gefuhlsmeter)
	$AnimationPlayer.play ("idle")
	$AnimationPlayer2.play("gegner idle")
	$TextureProgress.value = gefuhlsmeter
	Button_visible()

	

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
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
			Button_visible()
			Text_notvisible()
			return
		
		else:
			print (answerbox.visible_characters)
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
			if answerbox.visible_characters > 0:
				answerbox.visible_characters = answerbox.text.length()
				if answerbox.text.length() < 60:
					var answer_size =answerbox.get_font("normal_font").get_string_size(answerbox.text).x
					var answer_color_size = answer_size*answerbox.visible_characters/answerbox.text.length()
					answercolor.margin_right= answer_color_size + (margin_offset*2) -answer_size/2
					answercolor.margin_left = -answer_size/2 -( margin_offset* 3)
				if answerbox.text.length() > 60:
					var text_size = (answerbox.get_font("normal_font").get_string_size(answerbox.text).x)/1.9
					var color_size = (text_size * answerbox.visible_characters/answerbox.text.length())
					answercolor.margin_left =  -text_size/2 -( margin_offset* 2)
					answercolor.margin_right= color_size*2.2 + (margin_offset*2) -text_size/2
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
		changemeter(gefuhl)
		return
	changemeter(gefuhl)
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
		Button_visible()
		Text_notvisible()
		timertime (Time)
		return
	$AnimationPlayer.play ("Camera gegner")
	yield(get_tree().create_timer(0.4), "timeout")
	
	print (amount)
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
			
		answerbox.visible_characters+= 1
			
		$AnimationPlayer2.play("Reden")
		
		
		$"Speech gegner".play()
		
		
		$Timer.start()
		yield($Timer,"timeout")
		
	if gefuhlsmeter > 16:
		$AnimationPlayer2.play("Wut")
		finished = false
		
		var you_won = disqualifiedscreen.instance()
		yield($AnimationPlayer2,"animation_finished")
		#timertime(Time)
		add_child(you_won)
		var dir = Directory.new()
		dir.remove(path1)
		return
	if gefuhlsmeter == 2:
		$AnimationPlayer2.play("angst")
		finished = false
		var you_won = giveupscreen.instance()
		yield($AnimationPlayer2,"animation_finished")
		$AnimationPlayer2.play("gegner idle")
		#timertime(Time)
		add_child(you_won)
		var dir = Directory.new()
		dir.remove(path1)
		return
	$AnimationPlayer2.play("gegner idle")
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

func Button_visible():
	$ancher_text/Button4.visible =  visible
	if phrasNum[3] == phrasNum [4]:
		return
	if phrasNum [1] < phrasNum [2]:
		ChekButton.visible = visible
	if phrasNum [5] < phrasNum [6]:
		intimitateButton.visible = visible
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

func changemeter(gefuhl: float) -> int :
	if gefuhlr:
		gefuhlsmeter = gefuhl
		if gefuhlsmeter == 9:
			$ancher_answer/SitzengegnerGesicht.modulate = Color(1,1,1,0)
		if gefuhlsmeter < 9:
			var x = (-gefuhlsmeter /8)+0.975
			$ancher_answer/SitzengegnerGesicht.modulate = Color(1,1,1,x)
		if gefuhlsmeter > 9:
			var x = ((gefuhlsmeter /45)  -0.15)+0.43
		
			$ancher_answer/SitzengegnerGesicht.modulate = Color(x,0.24,0.06,1)
			$TextureProgress.value = gefuhl
		gefuhlr =false
		return 1
	gefuhlsmeter = gefuhlsmeter+ gefuhl
	$TextureProgress.value = gefuhlsmeter
	if gefuhlsmeter == 9:

		$ancher_answer/SitzengegnerGesicht.modulate = Color(1,1,1,0)
	if gefuhlsmeter < 9:
		var x = (-gefuhlsmeter /8)+0.975
		print (x)
		$ancher_answer/SitzengegnerGesicht.modulate = Color(1,1,1,x)
	if gefuhlsmeter > 9:
		var x = ((gefuhlsmeter /45)  -0.15)+0.43
		
		$ancher_answer/SitzengegnerGesicht.modulate = Color(x,0.24,0.06,1)
	return 1

func changescene():
	data_lvl["gegner"]["skriptreden"]
	data_lvl["gegner"]["gefühlsmeter"] = gefuhlsmeter
	save_game()
	get_tree().change_scene("res://Data/Levels/Level1.tscn")

func _on_Button3_button_down():
	phrasNum [0] = phrasNum[1]
	Button_notvisible()
	
	nextPhrase()
	if phrasNum[1] < phrasNum[2]:
		phrasNum[1]= phrasNum[1] +1
		return

func _on_Button2_button_down():
	phrasNum [0] =phrasNum [5]
	Button_notvisible()
	if gefuhlsmeter == 3:
		phrasNum[0] = 22
	nextPhrase()
	if phrasNum [5] < phrasNum [6]:
		phrasNum [5] = phrasNum [5] +1
		return

func _on_Button_button_down():
	phrasNum [0] = phrasNum [3]
	Button_notvisible()
	if gefuhlsmeter >= 15:
		phrasNum[0] = 24
		var x = ((gefuhlsmeter /45)  -0.15)+0.43
		$ancher_answer/gesicht.modulate = Color(x,0.24,0.06,1)
	nextPhrase()
	if phrasNum [3] < phrasNum [4]:
		phrasNum [3]= phrasNum [3] +1
		return

func _on_Button4_button_down():
	timertime(30)
	_on_Uhr_reden_Time_zero()
