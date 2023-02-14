extends Control

var terms: PackedStringArray
var description: PackedStringArray

var correct_things: Array

@onready var term_object = get_node("Label")
@onready var writing_animation = get_node("AnimationPlayer")

var current_number = 0

func show_writing_prompt(selected_number):
	var file = FileAccess.open("res://Set" + str(selected_number) + ".txt", FileAccess.READ)
	get_node("Name").set("text", file.get_line())
	# Set visibility of stuff
	self.set("visible", true)
	# Now add those lovely terms onto that array
	var next_line = file.get_line()
	while next_line != "":
		# idk this is how you fill a bool array I guess...
		correct_things.append(false)
		# load them beutiful stuff.
		terms.append(next_line)
		next_line = file.get_line()
		if next_line == "":
			description.append("null")
		else:
			description.append(next_line)
		next_line = file.get_line()
	# NOW... load the first term
	term_object.set("text", terms[0])
	
	writing_animation.play("appear")

var green = 0
var red = 0

func _process(delta):
	term_object.set("theme_override_colors/font_color", Color(red, green, 0, 1))
	if red >= 0:
		red -= (delta / 2)
	if green >= 0:
		green -= (delta / 2)

func _on_answer_edit_text_submitted(new_text: String):
	if new_text.to_upper() == description[current_number].to_upper():
		correct_things[current_number] = true
		green += 1
	else:
		correct_things[current_number] = false
		red += 1
	# quality of life feature
	get_node("AnswerEdit").set("text", "")
	# add a number and see if it goes over the terms
	current_number += 1
	if terms.size() - 1 < current_number:
		current_number = 0
	# Now display it!
	term_object.set("text", terms[current_number])
