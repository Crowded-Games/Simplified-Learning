extends Control

@export var Terms: PackedStringArray
@export var Descriptions: PackedStringArray
var Title = ""

func _on_title_text_changed(new_text):
	Title = new_text

func _on_term_pressed():
	var term = Label.new()
	term.set("text", "test")
	get_node("Term/Panel/ScrollContainer/VBoxContainer").add_child(term)

func _on_description_pressed():
	var description = Label.new()
	description.set("text", "test2")
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
	while Terms[number] != "":
		file.store_line(Terms[number])
		file.store_line(Descriptions[number])
		number += 1
	
	file = null

func _on_load_pressed():
	pass # Replace with function body.

func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scene/main_menu.tscn")
