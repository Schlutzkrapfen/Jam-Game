extends Navigation2D


export(float) var character_speed = 400.0
var path = []

onready var character = $Enemy

#func _process(delta):
	

func _update_navigation_path(start_position, end_position):
	# get_simple_path is part of the Navigation2D class.
	# It returns a PoolVector2Array of points that lead you
	# from the start_position to the end_position.
	path = get_simple_path(start_position, end_position, true)
	# The first point is always the start_position.
	# We don't need it in this example as it corresponds to the character's position.
	path.remove(0)
	set_process(true)


func _on_Enemy_Player_position(positions):
	_update_navigation_path(character.position,positions)
