extends Control

var terms: PackedStringArray
var description: PackedStringArray

@onready var term_object = get_node("Label")
@onready var writing_animation = get_node("AnimationPlayer")

@onready var correct_audio = get_parent().get_node("Background/Correct")
@onready var wrong_audio = get_parent().get_node("Background/Wrong")

var current_number = 0
# Same as the editor
var EndingText = "THISISTHEENDDONOTDOANYTHINGAFTERTHIS"

func show_writing_prompt(selected_number):
	writing_animation.play("appear")
	var file = FileAccess.open("res://Set" + str(selected_number) + ".txt", FileAccess.READ)
	get_node("Name").set("text", file.get_line())
	# Set visibility of stuff
	self.set("visible", true)
	# Now add those lovely terms onto that array
	var next_line = file.get_line()
	while next_line != EndingText:
		# load them beutiful stuff.
		terms.append(next_line)
		next_line = file.get_line()
		description.append(next_line)
		next_line = file.get_line()
	# NOW... load the first term
	current_number = randi_range(0, terms.size() - 1)
	term_object.set("text", terms[current_number])

var green = 0.0
var red = 0.0

func _process(delta):
	term_object.set("theme_override_colors/font_color", Color(red, green, 0, 1))
	if red >= 0:
		red -= (delta / 2)
	if green >= 0:
		green -= (delta / 2)

func _on_answer_edit_text_submitted(new_text: String):
	if new_text.to_upper() == description[current_number].to_upper():
		correct_audio.play()
		green += 1
	else:
		wrong_audio.play()
		red += 1
		# Save these to the wrong list for later
		get_node(".").get_parent().wrong_terms.append(terms[current_number])
		get_node(".").get_parent().wrong_descriptions.append(description[current_number])
	# quality of life feature
	get_node("AnswerEdit").set("text", "")
	# add a number and see if it goes over the terms
	current_number += 1
	if terms.size() - 1 < current_number:
		current_number = 0
	# Now display it!
	term_object.set("text", terms[current_number])

# On back button pressed
func Back():
	writing_animation.play("disappear")
