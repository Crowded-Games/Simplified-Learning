extends Control

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://Scene/main_menu.tscn")

var number = 0
var selected_number = 0
var something_selected = false
@onready var Lock_in_button = get_node("Menu Menu/Select Set")

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

var terms: PackedStringArray

func _on_select_set_pressed():
	var file = FileAccess.open("res://Set" + str(selected_number) + ".txt", FileAccess.READ)
	get_node("Flash Card/Name").set("text", file.get_line())
	# Set visibility of stuff
	get_node("Menu Menu").set("visible", false)
	get_node("Flash Card").set("visible", true)
	# Now add those lovely terms onto that array
	var next_term = file.get_line()
	while next_term != "":
		terms.append(next_term)
		next_term = file.get_line()
