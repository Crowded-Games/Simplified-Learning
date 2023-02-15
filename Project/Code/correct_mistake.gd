extends Control

var Wrong_terms: PackedStringArray
var Wrong_descriptions: PackedStringArray

func _ready():
	if !FileAccess.file_exists("res://WrongTerms.txt"):
		get_tree().change_scene_to_file("res://Scene/main_menu.tscn")
	var file = FileAccess.open("res://WrongTerms.txt", FileAccess.READ)
	var line = file.get_line()
	while line != "":
		Wrong_terms.append(line)
		line = file.get_line()
		Wrong_descriptions.append(line)
		line = file.get_line()
	
	# For now, just book it back to the main menu. I need to get this done sooner or later.
	get_tree().change_scene_to_file("res://Scene/main_menu.tscn")
