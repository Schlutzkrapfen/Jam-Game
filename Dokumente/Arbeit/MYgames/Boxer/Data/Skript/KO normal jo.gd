extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _ready():
	$AnimationPlayer.play("rollend")
func _on_Restart_pressed():
	get_tree().change_scene("res://Data/Levels/Level1.tscn")



func _on_Quit_pressed():

	get_tree().change_scene("res://Data/Levels/Menu.tscn")


func _on_Button_pressed():
	get_tree().change_scene("res://Data/Levels/Level2.tscn")

