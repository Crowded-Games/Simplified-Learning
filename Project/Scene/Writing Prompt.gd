extends Control

var terms: PackedStringArray
var description: PackedStringArray

@onready var term_object = get_node("Label")

var current_number = 0

func _on_studying_part_show_writing_prompt(selected_number):
	var file = FileAccess.open("res://Set" + str(selected_number) + ".txt", FileAccess.READ)
	get_node("Name").set("text", file.get_line())
	# Set visibility of stuff
	self.set("visible", true)
	# Now add those lovely terms onto that array
	var next_line = file.get_line()
	while next_line != "":
		terms.append(next_line)
		next_line = file.get_line()
		if next_line == "":
			description.append("null")
		else:
			description.append(next_line)
		next_line = file.get_line()
	term_object.set("text", terms[0])

func _on_answer_edit_text_submitted(new_text: String):
	if new_text.to_upper() == description[current_number].to_upper():
		print("correct!")
	else:
		print("boo!")
	# quality of life feature
	get_node("AnswerEdit").set("text", "")
	# add a number and see if it goes over the terms
	current_number += 1
	if terms.size() - 1 < current_number:
		current_number = 0
	# Now display it!
	term_object.set("text", terms[current_number])
