extends Control

var Terms: PackedStringArray
var Descriptions: PackedStringArray

var truth = false
var number = 0

var correct = 0
var wrong = 0

func _ready():
	# Open the file and load, as per usual
	var file = FileAccess.open("res://Set0.txt", FileAccess.READ)
	var line = file.get_line()
	line = file.get_line()
	while line != "":
		Terms.append(line)
		line = file.get_line()
		Descriptions.append(line)
		line = file.get_line()
	NewStuff()

func NewStuff():
	# If there is something remaining in the array...
	if number < Terms.size():
		get_node("Term").set("text", Terms[number])
		# This randi is deciding if this should be a true or false.
		match randi_range(1, 2):
			1:
				get_node("Description").set("text", Descriptions[number])
				truth = true
			2:
				var random_descriptions = randi_range(0, Descriptions.size() - 1)
				# This catches the case if a flash card has one item
				if Descriptions.size() == 1:
					get_node("Description").set("text", Descriptions[number])
				else:
					# In case the false answer is correct...
					while random_descriptions == number:
						random_descriptions = randi_range(0, Descriptions.size() - 1)
					get_node("Description").set("text", Descriptions[random_descriptions])
				truth = false
		number += 1
	else:
		# Set the stuff so it doesn't look wack.
		get_node("Term").set("text", "N/A")
		get_node("Description").set("text", "N/A")
		# Set the numbers, mason. You know what they mean
		get_node("Score/Correct").set("text", "Correct: " + str(correct))
		get_node("Score/Wrong").set("text", "Wrong: " + str(wrong))
		
		get_node("Score").set("visible", true)

func TruthAndFalse(thing: bool):
	if truth == thing:
		correct += 1
	else:
		wrong += 1
	get_node("AnimationPlayer").play("Refresh")

# Go back to the main menu
func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scene/main_menu.tscn")
