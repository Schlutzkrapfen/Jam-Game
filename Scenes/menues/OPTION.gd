extends Control



func _on_fullscreen_pressed():
	OS.window_fullscreen = ! OS.window_fullscreen


func _on_back_pressed():
	get_tree().change_scene("res://Scenes/menues/main menu.tscn")
