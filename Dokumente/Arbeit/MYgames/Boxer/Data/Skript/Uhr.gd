extends Label

var time = 30

var rou = 0


func clock():

	
	var mils = fmod(time,1)*100
	var secs = fmod(time,60)

	var time_passed = "%d %02d:%02d"  %[rou, secs ,mils]
	text =  time_passed

func _on_Node2D_Rounds(rounds):
	rou = rounds 
	clock()
