extends Control

signal menu_closed()


func _ready():
	pass

func _process(delta):
	pass

func _on_Resume_pressed():
	get_tree().paused = false
	emit_signal("menu_closed")


func _on_Upgrade_pressed():
	get_tree().change_scene("res://Scenes/menues/UpgradeMenu.tscn")



