extends Control

var TermNumber = 0
var DescriptionNumber = 0
@onready var TermNode = get_node("Term/Panel/ScrollContainer/VBoxContainer")
@onready var DescriptionNode = get_node("Description/Panel/ScrollContainer/VBoxContainer")

var Title = ""
var EndingText = "THISISTHEENDDONOTDOANYTHINGAFTERTHIS"

@export var font: Font

func _on_title_text_changed(new_text):
	Title = new_text

# These next two functions are made so that way making stuff is easy
func term_spawn(words: String):
	var term = LineEdit.new()
	term.expand_to_text_length = true
	term.name = "LineEdit" + str(TermNumber)
	term.set("text", words)
	term.add_theme_font_override("font", font)
	term.add_theme_font_size_override("font", 20)
	term.set_placeholder(str(TermNumber))
	term.expand_to_text_length = true
	TermNode.add_child(term)
	TermNumber += 1

func description_spawn(words: String):
	var description = LineEdit.new()
	description.expand_to_text_length = true
	description.name = "LineEdit" + str(DescriptionNumber)
	description.set("text", words)
	description.add_theme_font_override("font", font)
	description.add_theme_font_size_override("font", 20)
	description.set_placeholder(str(DescriptionNumber))
	description.expand_to_text_length = true
	DescriptionNode.add_child(description)
	DescriptionNumber += 1

func Add_Line_Edits():
	# Terms (left side)
	term_spawn("")
	# Descriptions (right side)
	description_spawn("")

func _on_save_pressed():
	# Open a new file that does not exist so it doesn't overwrite stuff, then store the title
	var number = 0
	while FileAccess.file_exists("res://Set" + str(number) + ".txt"):
		number += 1
	var file = FileAccess.open("res://Set" + str(number) + ".txt", FileAccess.WRITE)
	file.store_line(Title)
	# For every term, there should be a discription.
	number = 0
	while number != TermNumber:
		file.store_line(TermNode.get_node("LineEdit" + str(number)).get("text"))
		file.store_line(DescriptionNode.get_node("LineEdit" + str(number)).get("text"))
		number += 1
	file.store_line(EndingText)
	
	file = null

# below are loading stuff
var LoadSetNumber = -1

func _on_load_number_text_changed(new_text):
	LoadSetNumber = int(new_text)

func _on_load_pressed():
	if LoadSetNumber != -1 and FileAccess.file_exists("res://Set" + str(LoadSetNumber) + ".txt"):
		var file = FileAccess.open("res://Set" + str(LoadSetNumber) + ".txt", FileAccess.READ)
		var current_line = file.get_line()
		get_node("Title").set("text", current_line)
		Title = current_line
		current_line = file.get_line()
		# Re-add the fun stuff
		while current_line != EndingText:
			# Add terms to the term container
			term_spawn(current_line)
			current_line = file.get_line()
			# add descriptions to the description container
			description_spawn(current_line)
			# Restart to the beginning of the while loop
			current_line = file.get_line()

# Below are stuff about deleting
var DeleteSetNumber = -1

func _on_delete_number_text_changed(new_text):
	DeleteSetNumber = int(new_text)

func _on_delete_pressed():
	if DeleteSetNumber != 1:
		return
	# Get the children to make it easier to delete them.
	var term_children = TermNode.get_children()
	var description_children = DescriptionNode.get_children()
	# Delete everything
	term_children[DeleteSetNumber].queue_free()
	description_children[DeleteSetNumber].queue_free()
	# Set back these numbers so it don't go ape
	TermNumber -= 1
	DescriptionNumber -= 1

var MoveToNumber = -1
var MoveFromNumber = -1

func _on_move_to_text_changed(new_text):
	MoveToNumber = int(new_text)

func _on_move_from_text_changed(new_text):
	MoveFromNumber = int(new_text)

func _on_swap_pressed():
	var ToNode
	var FromNode
	# Catch bullshit
	if (MoveToNumber > TermNumber && MoveFromNumber > TermNumber) || MoveToNumber == -1 || MoveFromNumber == -1:
		return
	# Terms!
	ToNode = TermNode.get_node("LineEdit" + str(MoveToNumber))
	FromNode = TermNode.get_node("LineEdit" + str(MoveFromNumber))
	Swap_Lines(ToNode, FromNode)
	# Descriptions!
	ToNode = DescriptionNode.get_node("LineEdit" + str(MoveToNumber))
	FromNode = DescriptionNode.get_node("LineEdit" + str(MoveFromNumber))
	Swap_Lines(ToNode, FromNode)

func Swap_Lines(ToNode, FromNode):
	ToNode.set_placeholder(str(MoveFromNumber))
	FromNode.set_placeholder(str(MoveToNumber))
	# get the parent of this node, so the move_child doesn't bug
	ToNode.get_parent().move_child(ToNode, MoveFromNumber)
	FromNode.get_parent().move_child(FromNode, MoveToNumber)
	# Turn this one temp so it doesn't error out
	FromNode.name = "temp"
	# Do the renaming this time
	ToNode.name = "LineEdit" + str(MoveFromNumber)
	FromNode.name = "LineEdit" + str(MoveToNumber)

func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scene/main_menu.tscn")
