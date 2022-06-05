extends CanvasLayer


var path = "res://Data/Save files//data.json"
var path1 = "res://Data/Save files//datalvl1.json"
var path2 = "res://Data/Save files/daralvl2.json"
var default_data_lvl1 = {}
var game_data = {}
var  default_data_lvl2 = {}
var level = 0

onready var display_option_btnn = $"Popup/PanelContainer/MarginContainer/GridContainer/Display option button"
onready var master_slider = $"Popup/PanelContainer/MarginContainer/GridContainer/Master Volume"
onready var musik_slider = $"Popup/PanelContainer/MarginContainer/GridContainer/Musik Volume"
onready var SFX_slider = $"Popup/PanelContainer/MarginContainer/GridContainer/SFX Volume"




func _on_Restart_pressed():
	game_data["levels_complete "] = []
	save_data()
	get_tree().change_scene("res://Data/Levels/Level0.tscn")


func _on_Quit_pressed():
	get_tree().quit()

func _ready():
	load_data()

	if game_data["levels_complete"].empty():
		$"Camera2D/Rows/CenterContainer/VBoxContainer/Continue".visible = false
	display_option_btnn.select(1 if game_data["options"]["fullscreen_on"] else 0)
	GlobalSettings.toggle_fullscreen(game_data["options"]["fullscreen_on"])
	master_slider.value = game_data["options"]["master_vol"]
	musik_slider.value =game_data["options"]["music_vol"]
	SFX_slider.value = game_data["options"]["SFX_vol"]

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
			"death": [0,0,0],
			"levels_complete":[],#0 is good 1 is nutral 2 is bad
			}
	
		save_data()
	var dir = Directory.new()
	dir.remove(path1)
	dir.remove(path2)
	file.open(path,File.READ)
	game_data = file.get_var()
	file.close()
	
func save_data():
	var file = File.new()
	file.open(path,File.WRITE)
	file.store_var(game_data)
	file.close()

func _on_Setings_pressed():
	$Popup.popup()

func _on_Display_option_button_item_selected(index):
	GlobalSettings.toggle_fullscreen(true if index ==1 else false)
	game_data["options"]["fullscreen_on"] = true if index == 1 else false
	save_data()


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
	


func _on_Continue_pressed():
	print(game_data["levels_complete"].size())
	level = game_data["levels_complete"].size()
	
	get_tree().change_scene("res://Data/Levels/Level"+String (level)+".tscn")
