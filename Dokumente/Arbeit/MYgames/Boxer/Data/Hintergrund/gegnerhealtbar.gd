extends TextureProgress



func _on_Settings_isvisible():# is connected to settings and is for showing if the button shuld be visible
	visible = true


func _on_Pilot_sam_health_changed_enemy(new_helth):
	value = new_helth


func _on_Level2_Healt_lvlStartgegner(helth_ganersart):
	value = helth_ganersart


func _on_rolling_joe_health_changed_enemy(new_helth):
	value = new_helth


func _on_Level1_Healt_lvlStartgegner(helth_ganersart):
	value = helth_ganersart
