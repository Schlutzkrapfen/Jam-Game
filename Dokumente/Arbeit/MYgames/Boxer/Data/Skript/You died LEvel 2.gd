extends CanvasLayer



func _on_Restart_pressed():
	get_tree().change_scene("res://Data/Levels/Level2.tscn")



func _on_Quit_pressed():

	get_tree().change_scene("res://Data/Levels/Menu.tscn")

