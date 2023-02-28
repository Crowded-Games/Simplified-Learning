extends Control

var terms: PackedStringArray
var description: PackedStringArray

@onready var choice_animator = get_node("AnimationPlayer")

var current_number = 0
var required_amount_of_presses = 3
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
	get_node("Term").set("text", terms[0])
	get_node("AnimationPlayer").play("appear")

var current_amount_of_presses = 0

func ButtonPress(ButtNumber: int):
	if get_node("Button" + str(ButtNumber)).get("text") == description[current_number]:
		current_amount_of_presses += 1
	else:
		print("Boo!")
		RefreshStuff()
	if current_amount_of_presses == required_amount_of_presses:
		print("Correct!")
		RefreshStuff()

func RefreshStuff():
	current_amount_of_presses = 0
	current_number += 1
	print("Now I should do some shuffling, but I am bored.")

func Back():
	get_node("AnimationPlayer").play("disappear")
