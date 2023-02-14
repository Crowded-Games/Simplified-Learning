extends Control

var selected_number = -1

@export var words: PackedStringArray
# Get a random inspirational text
func _ready():
	get_node("Label").set("text", words[randi_range(0, words.size() - 1)])

signal show_flash_card

signal show_writing_prompt

signal show_multiple_choice

# once the bloody "disappear" animation is done, do this
func show_the_studying():
	# CHANGE THIS LATER SO IT PROPERLY RANDOMIZES
	match(randi_range(2, 2)):
		1:
			emit_signal("show_flash_card", selected_number)
		2:
			emit_signal("show_writing_prompt", selected_number)
		3:
			emit_signal("show_multiple_choice", selected_number)

# This is a reciever method from the study part.
func _on_studying_part_show_between_text(num):
	selected_number = num
	get_node("AnimationPlayer").play("animation")
