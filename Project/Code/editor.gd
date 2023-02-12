extends Control

@export var Terms: PackedStringArray
@export var Descriptions: PackedStringArray

var Title = ""
var TermThing = ""
var DescriptionThing = ""

func _on_title_text_changed(new_text):
	Title = new_text

func _on_term_edit_text_changed(new_text):
	TermThing = new_text

func _on_term_pressed():
	var term = Label.new()
	term.set("text", TermThing)
	Terms.append(TermThing)
	get_node("Term/Panel/ScrollContainer/VBoxContainer").add_child(term)

func _on_description_edit_text_changed(new_text):
	DescriptionThing = new_text

func _on_description_pressed():
	var description = Label.new()
	description.set("text", DescriptionThing)
	Descriptions.append(DescriptionThing)
	get_node("Description/Panel/ScrollContainer/VBoxContainer").add_child(description)

func _on_save_pressed():
	# Open a new file that does not exist so it doesn't overwrite stuff, then store the title
	var number = 0
	while FileAccess.file_exists("res://Set" + str(number) + ".txt"):
		number += 1
	var file = FileAccess.open("res://Set" + str(number) + ".txt", FileAccess.WRITE)
	file.store_line(Title)
	# For every term, there should be a discription.
	number = 0
	print(Terms.size())
	while Terms.size() != number:
		file.store_line(Terms[number])
		file.store_line(Descriptions[number])
		number += 1
	
	file = null

var LoadSetNumber = -1

func _on_load_pressed():
	if LoadSetNumber != -1 and FileAccess.file_exists("res://Set" + str(LoadSetNumber) + ".txt"):
		var file = FileAccess.open("res://Set" + str(LoadSetNumber) + ".txt", FileAccess.READ)
		var current_line = file.get_line()
		get_node("Title").set("text", current_line)
		Title = current_line
		
		# WARNING: CURRENT CODE DOES NOT ADD LABELS TO THE PANELS.
		while current_line != "":
			Terms.append(current_line)
			current_line = file.get_line()
			if current_line == "":
				Descriptions.append("null")
			else:
				Descriptions.append(current_line)
			current_line = file.get_line()

func _on_load_number_text_changed(new_text):
	LoadSetNumber = int(new_text)

func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scene/main_menu.tscn")
