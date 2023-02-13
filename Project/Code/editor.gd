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
	# Stop nothing from going through
	if TermThing == "":
		return
	# Add term label to the scene
	var term = Label.new()
	term.set("text", TermThing)
	Terms.append(TermThing)
	get_node("Term/Panel/ScrollContainer/VBoxContainer").add_child(term)
	# Reset
	get_node("Term/TermEdit").set("text", "")
	TermThing = ""

func _on_description_edit_text_changed(new_text):
	DescriptionThing = new_text

func _on_description_pressed():
	# Stop nothing from going through
	if DescriptionThing == "":
		return
	# Add description label to the scene
	var description = Label.new()
	description.set("text", DescriptionThing)
	Descriptions.append(DescriptionThing)
	get_node("Description/Panel/ScrollContainer/VBoxContainer").add_child(description)
	# Reset
	get_node("Description/DescriptionEdit").set("text", "")
	DescriptionThing = ""

func _on_save_pressed():
	# Open a new file that does not exist so it doesn't overwrite stuff, then store the title
	var number = 0
	while FileAccess.file_exists("res://Set" + str(number) + ".txt"):
		number += 1
	var file = FileAccess.open("res://Set" + str(number) + ".txt", FileAccess.WRITE)
	file.store_line(Title)
	# For every term, there should be a discription.
	number = 0
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
		current_line = file.get_line()
		# Re-add the fun stuff
		while current_line != "":
			# Add terms to the term container
			Terms.append(current_line)
			var term = Label.new()
			term.set("text", current_line)
			get_node("Term/Panel/ScrollContainer/VBoxContainer").add_child(term)
			current_line = file.get_line()
			# add descriptions to the description container
			Descriptions.append(current_line)
			var description = Label.new()
			description.set("text", current_line)
			get_node("Description/Panel/ScrollContainer/VBoxContainer").add_child(description)
			# Restart to the beginning of the while loop
			current_line = file.get_line()

func _on_load_number_text_changed(new_text):
	LoadSetNumber = int(new_text)

var DeleteSetNumber = -1

func _on_delete_number_text_changed(new_text):
	DeleteSetNumber = int(new_text)

func _on_delete_pressed():
	# Get the children to make it easier to delete them.
	var term_children = get_node("Term/Panel/ScrollContainer/VBoxContainer").get_children()
	var description_children = get_node("Description/Panel/ScrollContainer/VBoxContainer").get_children()
	# Delete everything
	term_children[DeleteSetNumber].queue_free()
	description_children[DeleteSetNumber].queue_free()
	Terms.remove_at(DeleteSetNumber)
	Descriptions.remove_at(DeleteSetNumber)

func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scene/main_menu.tscn")
