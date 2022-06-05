tool
extends RichTextEffect
class_name RichTextGhost

# Syntax: [ghost freq=5.0 span=10.0][/ghost]

# Define the tag name.
var bbcode = "thinking"

func _process_custom_fx(char_fx):
	# Get parameters, or use the provided default value if missing.
	var speed = char_fx.env.get("freq", 1.0)
	var span = char_fx.env.get("span", 5.0)
	
	var alpha = sin(char_fx.elapsed_time) *0.2 + 0.5
	
	char_fx.color.a = alpha
	return true
