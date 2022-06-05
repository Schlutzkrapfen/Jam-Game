extends Label

var time = 30
var rou
var time_true = true

func _physics_process(delta):
	if time > 0 and time_true:
		time  -= delta
	
	var mils = fmod(time,1)*100
	var secs = fmod(time,60)
	
	
	var time_passed = "%d %02d:%02d"  %[rou, secs ,mils]
	text =  time_passed
	if time < 6:
		var sexs = "%d" %[secs]
		$CanvasLayer/Label.text = sexs
		$CanvasLayer/AnimationPlayer.play("Uhr")


func _on_Level1_Rounds(rounds):
	rou = rounds 
	

func _on_Settings_menuclosed():
	time_true = true

func _on_Settings_menuopen():
	time_true = false
