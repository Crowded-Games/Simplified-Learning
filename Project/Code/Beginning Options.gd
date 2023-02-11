extends CenterContainer

@onready var animator = get_node("AnimationPlayer")

func _on_continue_pressed():
	# the more options I add the bigger this IF statement gets.
	if get_node("HFlowContainer/OptionButton").get_selected() != -1:
		if get_node("HFlowContainer/OptionButton2").get_selected() != -1:
			print("thank you. Continue")

# This is used for the WELCOME portion
func _on_happyness_show_options():
	animator.play("appear")

# This is used for the settings portion
func _back_to_menu():
	get_tree().change_scene_to_file("res://Scene/main_menu.tscn")
