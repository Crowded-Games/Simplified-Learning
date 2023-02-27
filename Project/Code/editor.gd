extends Control

var TermNumber = 0
var DescriptionNumber = 0

var Title = ""
var EndingText = "THISISTHEENDDONOTDOANYTHINGAFTERTHIS"

func _on_title_text_changed(new_text):
	Title = new_text

func Add_Line_Edits():
	# Terms (left side)
	var term = LineEdit.new()
	term.expand_to_text_length = true
	term.name = "LineEdit" + str(TermNumber)
	TermNumber += 1
	get_node("Term/Panel/ScrollContainer/VBoxContainer").add_child(term)
	# Descriptions (right side)
	var description = LineEdit.new()
	description.expand_to_text_length = true
	description.name = "LineEdit" + str(DescriptionNumber)
	DescriptionNumber += 1
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
	while number != TermNumber:
		file.store_line(get_node("Term/Panel/ScrollContainer/VBoxContainer/LineEdit" + str(number)).get("text"))
		file.store_line(get_node("Description/Panel/ScrollContainer/VBoxContainer/LineEdit" + str(number)).get("text"))
		number += 1
	file.store_line(EndingText)
	
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
		while current_line != EndingText:
			# Add terms to the term container
			var term = LineEdit.new()
			term.set("text", current_line)
			term.expand_to_text_length = true
			get_node("Term/Panel/ScrollContainer/VBoxContainer").add_child(term)
			current_line = file.get_line()
			# add descriptions to the description container
			var description = LineEdit.new()
			description.set("text", current_line)
			description.expand_to_text_length = true
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
	# Set back these numbers so it don't go ape
	TermNumber -= 1
	DescriptionNumber -= 1

func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scene/main_menu.tscn")
