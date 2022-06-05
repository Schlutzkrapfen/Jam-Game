extends Node2D

var path = "res://Data/Dialogs/Intro.json"
var path1 = "res://Data/Save files/data.json"

export(float) var textSpeed = 0.5

var spacebuttontime = 0
var spacebutton = true
var game_data = {}

var phrasNum = [0,4,5,6,7,10,11]#phrasnum, giving boxgloves animations,easy,hard,for code,code, change für endscene
#0-3 Text, 5 schlechte antwort, 4 gute antwort 
const margin_offset = 8

var dialog = {}
var output = {}
var finished = false
var answer = false
var buttonswerevisible = false
var sceneischanged = true

onready var textbox = $RichTextLabel
onready var textcolor = $ColorRect

func _ready():
	dialog =load_game()
	$AnimationPlayer2.play("Idle familie")
	$AnimationPlayer.play("Start screen")
	$Timer.wait_time = textSpeed
	buttonnotVisible()
	yield($AnimationPlayer,"animation_finished")
	nextPhrase()
	load_data()
	
func load_data():
	var file = File.new()
	file.open(path1,File.READ)
	game_data = file.get_var()
	file.close()

func load_game():
	
	var file =File.new()
	assert(file.file_exists(path),"file not there")
	file.open(path, File.READ)
	var json =file.get_as_text()
	
	output = parse_json(json)
	
	if typeof(output) == TYPE_ARRAY:
		return output
	else:
		return []
	
func nextPhrase() -> void:
	if phrasNum[0]== phrasNum[6]:
		changeschen()
		return
		

	if phrasNum[0] >= len(dialog):
	
		queue_free()
		return
		
	finished = false
	
	
	textbox.bbcode_text = dialog[phrasNum[0]]["text"]
	textbox.visible_characters = 0
	

	if textbox.text.length() == 0:
		finished = false
		#nextanswer()
		return
	while textbox.visible_characters < textbox.text.length():
		
		textbox.visible_characters+= 1
		changesize()
		
		$Timer.start()

		$AnimationPlayer.play("reden")
		if phrasNum[0] <= phrasNum[3]:
			$"opa stimme".play()
		if phrasNum[0] > phrasNum[3]:
			$"thinking stimme".play()
		yield($Timer,"timeout")

	if phrasNum[0] == phrasNum[1]:
		$AnimationPlayer2.play("Handschuhe")
		yield($AnimationPlayer2,"animation_finished")
		$AnimationPlayer2.play("Idle familie")
	answer = true
	phrasNum[0] = phrasNum[0] +1
	finished = true
	
	return

func _process(delta):
#	if phrasNum[0] ==3:
#		$Sprite3.visible = true
#		$Sprite5.visible = true
#		return
	if finished and $Easy.visible != visible:
		spacebuttontime += delta
		if spacebuttontime > 3:
			spacevisible()
	if Input.is_action_just_pressed("ui_accept"):
		spacebuttontime = 0
		$Sprite2.visible =  false
		spacebutton = true
		if phrasNum[0] >= phrasNum[2] and phrasNum[0] < phrasNum [5] :

			if not buttonswerevisible:
				buttonVisible()
				Text_notvisible()
				
				return
			if not finished:
				textbox.visible_characters = textbox.text.length()
				changesize()
			if finished:
				
				
				if phrasNum[0] == phrasNum[4]:
					
					chanes_schen()
					
					return
				if phrasNum[0] == phrasNum[3]:
					game_data["levels_complete"]=[0]

					save_data()
					changeschen()
					return
				
			else:
				return
		if finished:
			if phrasNum[0]== phrasNum[5]:
				changeschen()
				return


			#Button_visible()
			Text_notvisible()
			nextPhrase()
			return
		if textbox.text.length() == 0:
			return
		
		else:
			
			
			textbox.visible_characters = textbox.text.length()
			changesize()
			
			
func Text_notvisible():
	textbox.visible_characters = 0
	textcolor.margin_right=0
	textcolor.margin_left = 0
	textbox.margin_right=0
	textbox.margin_left = 0

func buttonnotVisible():
	$Easy.visible = !visible
	$Normal.visible = !visible

func buttonVisible():
	$Easy.visible = visible
	$Normal.visible = visible

func _on_Button_button_down():
	$AnimationPlayer2.stop()
	$AnimationPlayer2.play("Schock")
	phrasNum[0] = phrasNum[3]
	buttonswerevisible = true
	buttonnotVisible()
	nextPhrase()
	
func _on_Button2_button_down():

	phrasNum[0] = phrasNum[2]
	buttonswerevisible = true
	buttonnotVisible()
	nextPhrase()
	
func chanes_schen():
	if sceneischanged:
		Text_notvisible()
		sceneischanged = false
		
		$AnimationPlayer.play("Change screen")
		finished = false
		yield($AnimationPlayer,"animation_finished")
		$AnimationPlayer2.play("Punch bildup")
		yield($AnimationPlayer2,"animation_finished")
		nextPhrase()
		
func changesize():
		
		if  get_viewport_rect().size.x > textbox.get_font("normal_font").get_string_size(textbox.text).x:
			var text_size = (textbox.get_font("normal_font").get_string_size(textbox.text).x)
			
			var color_size = (text_size * textbox.visible_characters/textbox.text.length())
			textcolor.margin_top = -39
			textcolor.margin_bottom = 34
			textcolor.margin_right= color_size + (margin_offset*2) -text_size/2
			textcolor.margin_left =  -text_size/2 -( margin_offset* 2)
			textbox.margin_top= -34
			textbox.margin_bottom = 39
			textbox.margin_right= text_size/2+ margin_offset
			textbox.margin_left = -text_size/2 - margin_offset
			
			$Sprite2.position.x = (color_size/2)
			$Sprite2.position.y = -40
		
		if get_viewport_rect().size.x <= textbox.get_font("normal_font").get_string_size(textbox.text).x and get_viewport_rect().size.x  > textbox.get_font("normal_font").get_string_size(textbox.text).x/2:
			
			var text_size = (textbox.get_font("normal_font").get_string_size(textbox.text).x)/1.9
			var color_size = (text_size * textbox.visible_characters/textbox.text.length())
			textcolor.margin_top = -80
			textcolor.margin_bottom = 70
			
			textcolor.margin_left =  -text_size/2 -( margin_offset* 2)
			textbox.margin_top= -70
			textbox.margin_bottom = 80
			textbox.margin_right= text_size/2+ margin_offset
			textbox.margin_left = -text_size/2 - margin_offset
			if textbox.visible_characters < textbox.text.length()/2:
				textcolor.margin_right= color_size*2 + (margin_offset*2) -text_size/2
			if textbox.visible_characters == textbox.text.length():
				textcolor.margin_right= color_size + (margin_offset*2) -text_size/2
			$Sprite2.position.x = (color_size/2)
			$Sprite2.position.y = -80
		if get_viewport_rect().size.x <= textbox.get_font("normal_font").get_string_size(textbox.text).x/2:
			var text_size = (textbox.get_font("normal_font").get_string_size(textbox.text).x)/1.9
			var color_size = (text_size * textbox.visible_characters/textbox.text.length())
			textcolor.margin_top = -120
			textcolor.margin_bottom = 105
			textcolor.margin_left =  -text_size/3 -( margin_offset* 3)
			textbox.margin_top= -105
			textbox.margin_bottom = 120
			textbox.margin_right= text_size/3+ margin_offset
			textbox.margin_left = -text_size/3- margin_offset
			if textbox.visible_characters < textbox.text.length()/3:
				textcolor.margin_right= color_size *2.7 + (margin_offset*2) -text_size/2
			if textbox.visible_characters == textbox.text.length():
				textcolor.margin_right= color_size/1.2 + (margin_offset*2) -text_size/2
			$Sprite2.position.x = (color_size/1.2 + (margin_offset*2) -text_size/2)
			$Sprite2.position.y = -120
		
		
func spacevisible():
	if spacebutton:
		spacebutton = false
		$Sprite2.visible = visible
		
		$AnimationPlayer.play("Spacebar")

func changeschen():
	$AnimationPlayer.play("End screen")
	finished = false
	yield($AnimationPlayer,"animation_finished")
	get_tree().change_scene("res://Data/Levels/Level1.tscn")
	
func angryParants():
	$AnimationPlayer2.play("angryparants")
	game_data["levels_complete"]=[2]

	save_data()
	yield($AnimationPlayer2,"animation_finished")

func save_data():
	var file = File.new()
	file.open(path1,File.WRITE)
	file.store_var(game_data)
	file.close()
