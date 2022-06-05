extends Node2D
var spawner = true
var rand = RandomNumberGenerator.new()
var Wolke = load("res://Data/Hintergrund/Wolke.tscn")
var Wolke1 = load("res://Data/Hintergrund/Wolke1.tscn")
func _ready():
	spawnerd()




func spawnerd():
	while spawner:
		var Fenster = Wolke.instance()
		rand.randomize()
		var y = rand.randf_range(-30,30)
		rand.randomize()
		var x = rand.randf_range(150,200)
		Fenster.position.y = y
		Fenster.position.x = x
		add_child(Fenster)
		$Timer.start()
		yield ($Timer,"timeout")
		var Fenster1 = Wolke1.instance()
		rand.randomize()
		var y1 = rand.randf_range(-30,30)
		rand.randomize()
		var x1 = rand.randf_range(150,200)
		Fenster1.position.y = y1
		Fenster1.position.x = x1
		add_child(Fenster1)
		
		$Timer.start()
		yield ($Timer,"timeout")
		



