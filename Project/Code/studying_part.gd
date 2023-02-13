extends Control

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://Scene/main_menu.tscn")

var number = 0
var selected_number = 0
var something_selected = false
@onready var Lock_in_button = get_node("Menu Menu/Select Set")
@onready var menu_animation = get_node("Menu Menu/AnimationPlayer")

# This might be complicated, so lets take it slow.
func _ready():
	# In the future, the sets will increase from 0 to infinity. Loads of sets! it iterates through them until
	# it hits a snag
	while FileAccess.file_exists("res://Set" + str(number) + ".txt"):
		# Open a file and create a new button. Set the text from the first line and add child to the VBoxContainer
		var file = FileAccess.open("res://Set" + str(number) + ".txt", FileAccess.READ)
		var button = Button.new()
		button.text = file.get_line()
		get_node("Menu Menu/VBoxContainer").add_child(button)
		# Next, connect a signal from the button. On press, set the selected number to whatever it was given
		# via the editor description. I don't want to attach a script to make this work.
		button.connect("pressed", func(): 
			selected_number = button.get("editor_description")
			Lock_in_button.set("visible", true))
		# now set the editor description to be a number
		button.set("editor_description", str(number))
		# Count up
		number += 1
	menu_animation.play("appear")

# All the code below is regarding flash card variables and the select script to go to flash cards
var terms: PackedStringArray
var description: PackedStringArray

var term_number = 0
@onready var term_object = get_node("Flash Card/ColorRect/CenterContainer/Label")
var flipped = false

@onready var card_animator = get_node("Flash Card/AnimationPlayer")
# TO DO: MAKE THE SH## DISAPPEAR SO IT LOOKS GOOD.
func _on_select_set_pressed():
	var file = FileAccess.open("res://Set" + str(selected_number) + ".txt", FileAccess.READ)
	get_node("Flash Card/Name").set("text", file.get_line())
	# Set visibility of stuff
	get_node("Menu Menu").set("visible", false)
	get_node("Flash Card").set("visible", true)
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
# All the code below is regarding flash cards
func _on_left_pressed():
	if card_animator.is_playing():
		return
	term_number -= 1
	if term_number < 0:
		term_number = terms.size() - 1
	term_object.set("text", terms[term_number])
	flipped = false
	card_animator.play("Left")

func _on_right_pressed():
	if card_animator.is_playing():
		return
	term_number += 1
	if term_number > terms.size() - 1:
		term_number = 0
	term_object.set("text", terms[term_number])
	flipped = false
	card_animator.play("Right")

func _on_flip_pressed():
	if !card_animator.is_playing():
		card_animator.play("Flip")

func flip():
	if flipped == false:
		term_object.set("text", description[term_number])
	else:
		term_object.set("text", terms[term_number])
	flipped = !flipped
