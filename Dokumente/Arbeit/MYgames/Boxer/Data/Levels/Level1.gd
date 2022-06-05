extends Node2D

var path1 = "res://Data/Save files/datalvl1.json"
var path = "res://Data/Save files/data.json"
const GameOverScreen = preload("res://Data/UI/GameOverScreen.tscn")
const Youdiedscreen = preload("res://Data/UI/You died.tscn")
const Winscreen = preload("res://Data/UI/Winscreen.tscn")
const Yourunoutoftimescreen = preload("res://Data/UI/run out of time.tscn")
const KOscreen = preload("res://Data/UI/KO normal jo.tscn")

var restart = false
var finished = false
var game_data = {}


var Camera_shake_intensity = 0.0
var Camera_shake_duration = 0.0

enum Type {Random, punchs}
var Camera_shake_type = Type.Random

signal health_changed(new_helth)
signal Healt_lvlStart(helth_lvlstart)
signal Healt_lvlStartgegner(helth_ganersart)
signal Heltmeter(healtmeter_start)
signal Rounds(rounds)
signal finished()
signal position1(player)

func _on_Timer_timeout():
	if finished:
		on_player_runoutoftime()
		return
	save_game()
	get_tree().change_scene("res://Data/Levels/Level1,5.tscn")

func _ready() :
	
	$Timer.start()
	if restart:
		restart = false
		reset_data()
	load_game()
	load_level()
	var helth  = data_lvl["player"]["health"]
	var rounds =data_lvl["rounds"] 
	var helthg = data_lvl["gegner"]["health"]
	var healtmeter = data_lvl["gegner"]["gefühlsmeter"]
	emits_signal(helth,helthg,healtmeter)
	rounds.pop_front()
	var length  = rounds.size()
	length = -(length-3)
	if length ==3:
		finished = true
	emit_signal("Rounds",length)
	$Uhr/CanvasLayer.offset= get_viewport_rect().size /2
	$CanvasLayer/TextureProgress.rect_position.x = get_viewport_rect().size.x -120

func _physics_process(_delta):
	if $Player.position < $"rolling_joe".position:
		$Camera2D.position =($"rolling_joe".position +$Player.position)/2
		$Camera2D.zoom.x =(($"rolling_joe".position.x -$Player.position.x)/1000)+0.2
		$Camera2D.zoom.y =(($"rolling_joe".position.x -$Player.position.x)/1000)+0.2
	if $Player.position > $"rolling_joe".position:
		$Camera2D.position =($"rolling_joe".position +$Player.position)/2
		$Camera2D.zoom.x =(($Player.position.x-$"rolling_joe".position.x )/1000)+0.2

		$Camera2D.zoom.y =(($Player.position.x-$"rolling_joe".position.x )/1000)+0.2
	emit_signal("position1",$Player.position.x)
	if Camera_shake_duration <= 0:
		$Camera2D.offset = Vector2.ZERO
		Camera_shake_intensity = 0
		Camera_shake_duration = 0
	Camera_shake_duration = Camera_shake_duration -_delta
	
	var offset = Vector2.ZERO
	if Camera_shake_type == Type.Random:
		offset = Vector2(randf(),randf()) * Camera_shake_intensity
	if Camera_shake_type == Type.punchs:
		offset = Vector2(2,randf()/50)* Camera_shake_intensity
		
	$Camera2D.offset = offset



func emits_signal(helth: float, helthg : float,healtmeter : float) -> int :
	emit_signal("Healt_lvlStart", helth)
	emit_signal("health_changed",helth)
	emit_signal("Healt_lvlStartgegner",helthg)
	emit_signal("Heltmeter",healtmeter)
	return 1
	

var default_data = {
	
			"options" : {
			
			"fullscreen_on": false,
			"display_fps" : false,
			"brightness" : 100,
			"master_vol": 80,
			"music_vol" : 80,
			"SFX_vol" : 80
			},
			"death": [0,0,0],
			"levels_complete":[]

			}
			

var default_data_lvl1 = {
	"player" : {
		"level" : 1,
		"health" : 17
		},
	"gegner" : {
		"gefühlsmeter" : 9,
		"skriptreden" : [0,0,2,2,11,12,21],
		"health" : 15
		},
	"options" : {
		"music_volume" : 0.5,
		"cheat_mode" : false
		},
	"rounds": [1,2,3]
}

var data_lvl = { }

func load_game():
	var file = File.new()
	
	if  not file.file_exists(path1) :
		reset_data()
		return
	
	file.open(path1, file.READ)
	
	var text = file.get_as_text()
	
	data_lvl = parse_json(text)
	
	file.close()
func load_level():
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
			"levels_complete":[],
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


func save_game():
	var file
	
	file = File.new()
	
	file.open(path1, File.WRITE)
	
	file.store_line(to_json(data_lvl))
	
	file.close()



func reset_data():
	# Reset to defaults
	data_lvl = default_data_lvl1.duplicate(true)
	save_game()


func _on_Player_f(new_helth):
	data_lvl["player"]["health"] = new_helth
	emit_signal("health_changed",new_helth)
	


func _on_Player_health_changed(new_helth):
	data_lvl["player"]["health"] = new_helth
	emit_signal("health_changed",new_helth)


func _on_Player_died():
	$Timer.stop()
	var game_over = Youdiedscreen.instance()
	reset_data()
	yield(get_tree().create_timer(1), "timeout")
	emit_signal("finished")
	add_child(game_over)
	$AudioStreamPlayer.stop()

func _on_Settings_menuclosed():
	$Timer.start()


func _on_Settings_menuopen():
	
	$Timer.stop()

func on_player_runoutoftime():
	var game_over = Yourunoutoftimescreen.instance()
	reset_data()
	yield(get_tree().create_timer(1), "timeout")
	emit_signal("finished")
	add_child(game_over)
	$AudioStreamPlayer.stop()

func _on_Player_camara(intensity, duration, type):
	if intensity > Camera_shake_intensity and duration > Camera_shake_duration:
		Camera_shake_intensity = intensity
		Camera_shake_duration = duration
		Camera_shake_type = type


func _on_rolling_joe_died():
	$Timer.stop()
	var you_won = KOscreen.instance()
	reset_data()
	game_data["levels_complete"].append(1)
	if game_data["levels_complete"].size() > 2:
		game_data["levels_complete"][1]= 1
		game_data["levels_complete"].resize(2)
	save_data()
	yield(get_tree().create_timer(1), "timeout")
	add_child(you_won)
	$AudioStreamPlayer.stop()


func _on_rolling_joe_health_changed_enemy(new_helth):
	data_lvl["gegner"]["health"] = new_helth
	


