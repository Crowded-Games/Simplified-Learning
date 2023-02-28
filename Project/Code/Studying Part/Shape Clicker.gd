extends Control

var terms: PackedStringArray
var description: PackedStringArray

@onready var choice_animator = get_node("AnimationPlayer")

var current_number = 0
# Same as the editor
var EndingText = "THISISTHEENDDONOTDOANYTHINGAFTERTHIS"

func show_shape_clicker(selected_number):
	choice_animator.play("appear")
	var file = FileAccess.open("res://Set" + str(selected_number) + ".txt", FileAccess.READ)
	get_node("Name").set("text", file.get_line())
	# Set visibility of stuff
	self.set("visible", true)
	# Now add those lovely terms onto that array
	var next_line = file.get_line()
	while next_line != EndingText:
		terms.append(next_line)
		next_line = file.get_line()
		description.append(next_line)
		next_line = file.get_line()
	# Insert here a function to make the thing appear

func Back():
	get_node("AnimationPlayer").play("disappear")
