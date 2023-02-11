extends CenterContainer

@onready var animator = get_node("AnimationPlayer")
# Save stuff
@onready var Option1 = get_node("HFlowContainer/OptionButton")
@onready var Option2 = get_node("HFlowContainer/OptionButton2")

func _ready():
	# For the settings menu
	if FileAccess.file_exists("res://settings.txt"):
		var data = load_setting()
		Option1._select_int(int(data.substr(0, 1)))
		Option2._select_int(int(data.substr(1, 2)))

func _on_continue_pressed():
	# the more options I add the bigger this IF statement gets.
	if Option1.get_selected() != -1:
		if Option2.get_selected() != -1:
			save_setting()
	# Back to the main menu
	get_tree().change_scene_to_file("res://Scene/main_menu.tscn")

# This is used for the WELCOME portion
func _on_happyness_show_options():
	animator.play("appear")

# Saving the settings
func save_setting():
	var file = FileAccess.open("res://settings.txt", FileAccess.WRITE)
	file.store_string(str(Option1.get_selected()))
	file.store_string(str(Option2.get_selected()))
	file = null

func load_setting():
	var file = FileAccess.open("res://settings.txt", FileAccess.READ)
	var content = file.get_as_text()
	return content
