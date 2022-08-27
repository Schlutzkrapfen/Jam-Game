extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _on_Main_Menu_pressed():
	get_tree().change_scene("res://Scenes/menues/Main Menu.tscn")


func _on_Quit_pressed():
	get_tree().quit()


func _on_Button_pressed():
	get_tree().change_scene("res://Scenes/Game.tscn")
