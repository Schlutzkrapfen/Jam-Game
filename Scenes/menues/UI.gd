extends Control





func _on_play_pressed():
	get_tree().change_scene("res://Scenes/Level.tscn")
func _on_option_pressed():
	get_tree().change_scene("res://Scenes/menues/option.tscn")
func _on_quit_pressed():
	get_tree().quit()
