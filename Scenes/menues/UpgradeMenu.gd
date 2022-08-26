extends Control

onready var upgrades = $"PanelContainer/MarginContainer/Upgrades"

func _ready():
	pass

func _process(delta):
	
	upgrades.get_node("Coins").text = str("Gold : ", Game.gold)
	
	#labels
	upgrades.get_node("Ammo/Ammo_Label").text = str("Ammo upgrade : %s / 4 " % Game.ammo_up)
	upgrades.get_node("Health/Health_Label").text = str("Health upgrade : %s / 4 " % Game.health_up)
	upgrades.get_node("Damage/Damage_Label").text = str("Damage upgrade : %s / 4 " % Game.damage_up)
	
	#buttons
	if Game.ammo_up == 4:
		upgrades.get_node("Ammo/Ammo_Button").disabled = true
	if Game.health_up == 4:
		upgrades.get_node("Health/Health_Button").disabled = true
	if Game.ammo_up == 4:
		upgrades.get_node("Ammo/Ammo_Button").disabled = true
	
	

func _on_Ammo_Button_pressed():
	if Game.gold >= 500:
		Game.ammo_up += 1
		Game.gold -= 500


func _on_Health_Button_pressed():
	if Game.gold >= 500:
		Game.health_up += 1
		Game.gold -= 500

func _on_Damage_Button_pressed():
	if Game.gold >= 500:
		Game.damage_up += 1
		Game.gold -= 500

func _on_Main_Menu_pressed():
	get_tree().change_scene("res://Scenes/menues/Main Menu.tscn")


func _on_Play_Again_pressed():
	get_tree().change_scene("res://Scenes/Game.tscn")
