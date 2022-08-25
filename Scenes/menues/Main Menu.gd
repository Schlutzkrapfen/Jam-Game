extends Control


func _ready():
	pass


func _on_Play_pressed():
	get_tree().change_scene("res://Scenes/Game.tscn")


func _on_Option_pressed():
	$PanelContainer.hide()
	$Popup.show()


func _on_Exit_pressed():
	get_tree().quit()


func _on_FullScreen_pressed():
	OS.window_fullscreen = !OS.window_fullscreen


func _on_VSync_pressed():
	OS.vsync_enabled = !OS.vsync_enabled


func _on_Back_pressed():
	$PanelContainer.show()
	$Popup.hide()
