extends Control

var terms: PackedStringArray
var description: PackedStringArray

@onready var choice_animator = get_node("AnimationPlayer")

var current_number = -1
var required_amount_of_presses = 4
# Same as the editor
var EndingText = "THISISTHEENDDONOTDOANYTHINGAFTERTHIS"

func show_button_masher(selected_number):
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
	RefreshStuff()
	get_node("AnimationPlayer").play("appear")

var current_amount_of_presses = 0

func ButtonPress(ButtNumber: int):
	if get_node("AnimationPlayer").is_playing():
		return
	if get_node("Button" + str(ButtNumber)).get("text") == description[current_number]:
		current_amount_of_presses += 1
		get_node("AnimationPlayer").play("Button_Correct")
		RefreshStuff()
	else:
		current_amount_of_presses = 0
		current_number += 1
		# add wrong stuff
		get_node(".").get_parent().wrong_terms.append(terms[current_number])
		get_node(".").get_parent().wrong_descriptions.append(description[current_number])
		get_node("AnimationPlayer").play("Button_Wrong")
		RefreshStuff()

func RefreshStuff():
	if current_amount_of_presses == required_amount_of_presses:
		current_amount_of_presses = 0
		current_number += 1
	if current_number > terms.size() - 1:
		current_number = 0
	get_node("Term").set("text", terms[current_number])
	# Refresh the terms
	var random = randi_range(1, 2)
	match random:
		1:
			random = randi_range(0, description.size() - 1)
			while random == current_number:
				random = randi_range(0, description.size() - 1)
			get_node("Button1").set("text", description[random])
			get_node("Button2").set("text", description[current_number])
		2:
			random = randi_range(0, description.size() - 1)
			while random == current_number:
				random = randi_range(0, description.size() - 1)
			get_node("Button1").set("text", description[current_number])
			get_node("Button2").set("text", description[random])

func Back():
	get_node("AnimationPlayer").play("disappear")
