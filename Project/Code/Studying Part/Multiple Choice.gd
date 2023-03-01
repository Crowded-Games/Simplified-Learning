extends Control

var terms: PackedStringArray
var description: PackedStringArray

@onready var description_object = get_node("Description")
@onready var choice_animator = get_node("AnimationPlayer")

var current_number = 0
# Same as the editor
var EndingText = "THISISTHEENDDONOTDOANYTHINGAFTERTHIS"

func show_multiple_choice(selected_number):
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
	description_object.set("text", description[0])
	RedoAnswers()

# Button stuff for all 4 buttons
func answer_pressed(answer_number: int):
	if get_node("Buttons/Answer" + str(answer_number)).get("text").to_upper() == terms[current_number].to_upper():
		green += 1
	else:
		red += 1
		# Save these to the wrong list for later
		get_node(".").get_parent().wrong_terms.append(terms[current_number])
		get_node(".").get_parent().wrong_descriptions.append(description[current_number])
	# Now reset these dumb terms and descriptions :D
	RedoAnswers()

var green = 0.0
var red = 0.0
# Reaction for the colors doing things
func _process(delta):
	get_node("Description").set("theme_override_colors/font_color", Color(red, green, 0, 1))
	if red >= 0:
		red -= (delta * 1.1)
	if green >= 0:
		green -= (delta * 1.1)

# This giant function is to shuffle the answers as well as set another question. Large :D
func RedoAnswers():
	# Increment to the next description
	current_number += 1
	if current_number >= terms.size():
		current_number = 0
	# This goes up the buttons
	description_object.set("text", description[current_number])
	match(terms.size()):
		3:
			get_node("Buttons/Answer4").set("visible", false)
			# Set text
			var random_counter = randi_range(0, 2)
			var counter_counter = 0
			# Do fun text stuff
			while counter_counter <= 2:
				if random_counter > 2:
					random_counter = 0
				get_node("Buttons/Answer" + str(counter_counter + 1)).set("text", terms[random_counter])
				# Increment both counters so it doesn't bug
				random_counter += 1
				counter_counter += 1
			return
		2:
			get_node("Buttons/Answer4").set("visible", false)
			get_node("Buttons/Answer3").set("visible", false)
			# Set text
			if randi_range(0,1) == 0:
				get_node("Buttons/Answer2").set("text", terms[0])
				get_node("Buttons/Answer1").set("text", terms[1])
			else:
				get_node("Buttons/Answer1").set("text", terms[0])
				get_node("Buttons/Answer2").set("text", terms[1])
			return
		1:
			get_node("Buttons/Answer4").set("visible", false)
			get_node("Buttons/Answer3").set("visible", false)
			get_node("Buttons/Answer2").set("visible", false)
			# Set text
			get_node("Buttons/Answer1").set("text", terms[0])
			return
	# If there is 4 or more items, then we should still do stuff
	var temp_number = 1
	# Set text
	while temp_number <= 4:
		get_node("Buttons/Answer" + str(temp_number)).set("text", terms[randi_range(0, terms.size() - 1)])
		temp_number += 1
	# Now set the answer!
	get_node("Buttons/Answer" + str(randi_range(1, 4))).set("text", terms[current_number])

func Back():
	get_node("AnimationPlayer").play("disappear")
