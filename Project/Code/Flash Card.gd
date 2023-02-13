extends Control

var terms: PackedStringArray
var description: PackedStringArray

var term_number = 0
@onready var term_object = get_node("ColorRect/CenterContainer/Label")
var flipped = false

@onready var card_animator = get_node("AnimationPlayer")

func _on_studying_part_show_flash_card(selected_number):
	var file = FileAccess.open("res://Set" + str(selected_number) + ".txt", FileAccess.READ)
	get_node("Name").set("text", file.get_line())
	# Set visibility of stuff
	self.set("visible", true)
	# Now add those lovely terms onto that array
	var next_line = file.get_line()
	while next_line != "":
		terms.append(next_line)
		next_line = file.get_line()
		if next_line == "":
			description.append("null")
		else:
			description.append(next_line)
		next_line = file.get_line()
	term_object.set("text", terms[0])

func _on_left_pressed():
	# Don't want the animation to be interupted
	if card_animator.is_playing():
		return
	term_number -= 1
	if term_number < 0:
		term_number = terms.size() - 1
	term_object.set("text", terms[term_number])
	flipped = false
	card_animator.play("Left")

func _on_right_pressed():
	# Don't want the animation to be interupted
	if card_animator.is_playing():
		return
	term_number += 1
	if term_number > terms.size() - 1:
		term_number = 0
	term_object.set("text", terms[term_number])
	flipped = false
	card_animator.play("Right")

func _on_flip_pressed():
	# Don't want the animation to be interupted
	if !card_animator.is_playing():
		card_animator.play("Flip")

func flip():
	# Flip over to the other term
	if flipped == false:
		term_object.set("text", description[term_number])
	else:
		term_object.set("text", terms[term_number])
	flipped = !flipped
