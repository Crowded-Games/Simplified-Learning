extends Control

var Wrong_terms: PackedStringArray
var Wrong_descriptions: PackedStringArray
@export var middle_words: PackedStringArray

var advice_random = 2

@export_group("Advice")
@export var audio_advice: PackedStringArray
@export var writing_advice: PackedStringArray

# 0 means paper, 1 means computer
var writing_setting = -1
# 0 means yes sound, 1 means no sound
var sound_setting = -1

func _ready():
	# set the options for the thing to do stuff
	var setting_file = FileAccess.open("res://settings.txt", FileAccess.READ)
	writing_setting = int(setting_file.get_line())
	sound_setting = int(setting_file.get_line())
	# Load the wrong terms and descriptions
	if !FileAccess.file_exists("res://WrongTerms.txt"):
		get_tree().change_scene_to_file("res://Scene/main_menu.tscn")
	var file = FileAccess.open("res://WrongTerms.txt", FileAccess.READ)
	var line = file.get_line()
	while line != "":
		Wrong_terms.append(line)
		line = file.get_line()
		Wrong_descriptions.append(line)
		line = file.get_line()
	RefreshLines()

# Refreshes the whole thing so it don't do dumb stuff
func RefreshLines():
	if Wrong_terms.size() > 0:
		get_node("Term").set("text", Wrong_terms[0])
		get_node("Middle Words").set("text", middle_words[randi_range(0, middle_words.size() - 1)])
		get_node("Description").set("text", Wrong_descriptions[0])
		if sound_setting == 0:
			advice_random = randi_range(1, 2)
		match advice_random:
			1:
				get_node("Advice").set("text", audio_advice[randi_range(0, audio_advice.size() - 1)])
			2:
				if writing_setting == 0:
					get_node("Advice").set("text", "On your paper: " + writing_advice[randi_range(0, writing_advice.size() - 1)])
				elif writing_setting == 1:
					get_node("Advice").set("text", "On your computer: " + writing_advice[randi_range(0, writing_advice.size() - 1)])
	else:
		get_tree().change_scene_to_file("res://Scene/main_menu.tscn")

func _on_continue_pressed():
	Wrong_terms.remove_at(0)
	Wrong_descriptions.remove_at(0)
	RefreshLines()
