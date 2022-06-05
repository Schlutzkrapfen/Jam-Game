extends Popup


var path = "res://Data/Save files/data.json"
var path1 = "res://Data/Save files/datalvl1.json"
var path2 = "res://Data/Save files/datalvl2.json"
var default_data_lvl1 = {}
var game_data = {}
var menu_open = false
signal menuopen ()
signal menuclosed()
signal isvisible()

onready var display_option_btnn = $"CanvasLayer2/Popup/PanelContainer/MarginContainer/GridContainer/Display option button"
onready var master_slider = $"CanvasLayer2/Popup/PanelContainer/MarginContainer/GridContainer/Master Volume"
onready var musik_slider = $"CanvasLayer2/Popup/PanelContainer/MarginContainer/GridContainer/Musik Volume"
onready var SFX_slider = $"CanvasLayer2/Popup/PanelContainer/MarginContainer/GridContainer/SFX Volume"


func _ready():
	load_data()
	display_option_btnn.select(1 if game_data["options"]["fullscreen_on"] else 0)
	GlobalSettings.toggle_fullscreen(game_data["options"]["fullscreen_on"])
	master_slider.value = game_data["options"]["master_vol"]
	musik_slider.value =game_data["options"]["music_vol"]
	SFX_slider.value = game_data["options"]["SFX_vol"]
	
	
	if game_data["levels_complete"]==[0]:
		emit_signal("isvisible")
	$CanvasLayer.offset = (get_viewport_rect().size /2) - Vector2(175,200)
	$CanvasLayer2.offset = (get_viewport_rect().size /2) - Vector2(277.5,177.5)

func _process(_delta):
	if Input.is_action_just_pressed("settings") :
		if menu_open and $"CanvasLayer/Popup".visible == false :
			
			emit_signal("menuclosed")
			menu_open = false
			return
		if $"CanvasLayer2/Popup".visible == false :
			menu_open = true
			emit_signal("menuopen")
			$"CanvasLayer/Popup".popup()
		
			


func load_data():
	var file = File.new()
	if not file.file_exists(path):
		game_data =  {
			"options" : {
			
			"fullscreen_on": false,
			"display_fps" : false,
			"brightness" : 100,
			"master_vol": 80,
			"music_vol" : 80,
			"SFX_vol" : 80
			},
			"levels_complete ":[],
			"healtbar": false
			}
	
		save_data()


	file.open(path,File.READ)
	game_data = file.get_var()
	file.close()
	
func save_data():
	var file = File.new()
	file.open(path,File.WRITE)
	file.store_var(game_data)
	file.close()


func _on_Display_option_button_item_selected(index):
	GlobalSettings.toggle_fullscreen(true if index ==1 else false)
	game_data["options"]["fullscreen_on"] = true if index == 1 else false
	save_data()
	$CanvasLayer.offset = (get_viewport_rect().size /2) - Vector2(175,200)
	$CanvasLayer2.offset = (get_viewport_rect().size /2) - Vector2(277.5,177.5)


func _on_Master_Volume_value_changed(value):
	game_data["options"]["master_vol"] = value
	value = value -80
	GlobalSettings.update_master_vol(value)
	save_data()


func _on_Musik_Volume_value_changed(value):
	game_data["options"]["music_vol"] = value
	value = value -80
	GlobalSettings.update_musik_vol(value)
	save_data()
	

func _on_SFX_Volume_value_changed(value):
	game_data["options"]["SFX_vol"] = value
	value = value -80
	GlobalSettings.update_SFX_vol(value)
	save_data()
	


func _on_Restart_button_down():
	var dir = Directory.new()
	dir.remove(path1)
	dir.remove(path2)
	get_tree().change_scene("res://Data/Levels/Level1.tscn")


func _on_Quit_button_down():
	var dir = Directory.new()
	dir.remove(path1)
	dir.remove(path2)
	get_tree().change_scene("res://Data/Levels/Menu.tscn")


func _on_Setings_button_down():
	$"CanvasLayer2/Popup".popup()


func _on_Button_button_down():
	emit_signal("menuclosed")
	$"CanvasLayer/Popup".visible = false
	menu_open = false
