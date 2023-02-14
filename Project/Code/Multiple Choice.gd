extends Control

var terms: PackedStringArray
var description: PackedStringArray

@onready var description_object = get_node("Description")

var current_number = 0

func _on_studying_part_show_multiple_choice(selected_number):
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
	description_object.set("text", description[0])
	RedoAnswers()

# Button stuff for all 4 buttons
func answer_pressed(answer_number: int):
	if get_node("Answer" + str(answer_number)).get("text").to_upper() == terms[current_number].to_upper():
		print("Correct!")
	else:
		print("Wrong!")
	# Now reset these dumb terms and descriptions :D
	RedoAnswers()

func RedoAnswers():
	# Increment to the next description
	current_number += 1
	if current_number >= terms.size():
		current_number = 0
	# This goes up the buttons
	description_object.set("text", description[current_number])
	match(terms.size()):
		4:
			var temp_number = 1
			# Set text
			while temp_number <= terms.size():
				get_node("Answer" + str(temp_number)).set("text", terms[randi_range(0, terms.size() - 1)])
				temp_number += 1
			# Now set the answer!
			get_node("Answer" + str(randi_range(1, 4))).set("text", terms[current_number])
		3:
			get_node("Answer4").set("visible", false)
			# Set text
			var random_counter = randi_range(0, 2)
			var counter_counter = 0
			# Do fun text stuff
			while counter_counter <= 2:
				if random_counter > 2:
					random_counter = 0
				get_node("Answer" + str(counter_counter + 1)).set("text", terms[random_counter])
				# Increment both counters so it doesn't bug
				random_counter += 1
				counter_counter += 1
		2:
			get_node("Answer4").set("visible", false)
			get_node("Answer3").set("visible", false)
			# Set text
			if randi_range(0,1) == 0:
				get_node("Answer2").set("text", terms[0])
				get_node("Answer1").set("text", terms[1])
			else:
				get_node("Answer1").set("text", terms[0])
				get_node("Answer2").set("text", terms[1])
		1:
			get_node("Answer4").set("visible", false)
			get_node("Answer3").set("visible", false)
			get_node("Answer2").set("visible", false)
			# Set text
			get_node("Answer1").set("text", terms[0])
