extends Label

var time = 30
signal Time_zero()

func _ready():
	var mils = fmod(time,1)*100
	var secs = fmod(time,60)
	var mins = fmod(time,60*60) /60
	
	var time_passed ="%02d :%02d : %02d" %[mins, secs ,mils]
	text = time_passed


func _on_Button_button_down():
	time= 0
	var mils = fmod(time,1)*100
	var secs = fmod(time,60)
	var mins = fmod(time,60*60) /60
	var time_passed ="%02d :%02d : %02d" %[mins, secs ,mils]
	text = time_passed
	emit_signal("Time_zero")

