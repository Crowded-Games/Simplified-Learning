extends Control

var selected_number = 0
# This bottom number tells what signal should be sent
var signal_number = 0
var signal_maximum = 0

@export var words: PackedStringArray
# Get a random inspirational text
func _ready():
	get_node("Label").set("text", words[randi_range(0, words.size() - 1)])
	signal_maximum = get_node(".").get_parent().get("signal_maximum")

signal show_flash_card

signal show_writing_prompt

signal show_multiple_choice

# once the bloody "disappear" animation is done, do this
func show_the_studying():
	if signal_number == 0:
		signal_number = randi_range(1, 3)
	else:
		signal_number += 1
		if signal_number == signal_maximum + 1:
			signal_number = 1
	# CHANGE THIS LATER SO IT PROPERLY RANDOMIZES
	match(signal_number):
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
