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
# These signals go to their scripts to do stuff
signal show_flash_card

signal show_writing_prompt

# TO DO: MAKE THE SH## DISAPPEAR SO IT LOOKS GOOD.
func _on_select_set_pressed():
	emit_signal("show_flash_card", selected_number)
	get_node("Menu Menu").set("visible", false)
