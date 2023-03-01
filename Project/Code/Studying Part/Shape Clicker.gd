extends Control

var terms: PackedStringArray
var description: PackedStringArray

@onready var choice_animator = get_node("AnimationPlayer")

var current_number = 0
# Same as the editor
var EndingText = "THISISTHEENDDONOTDOANYTHINGAFTERTHIS"

func show_shape_clicker(selected_number):
	choice_animator.play("appear")
	var file = FileAccess.open("res://Set" + str(selected_number) + ".txt", FileAccess.READ)
	get_node("Name").set("text", file.get_line())
	# Set visibility of stuff
	self.set("visible", true)
	# Now add those lovely terms onto that array
	var next_line = file.get_line()
	while next_line != EndingText:
		terms.append(next_line)
		next_line = file.get_line()
		description.append(next_line)
		next_line = file.get_line()
	get_node("Term").set("text", terms[current_number])
	get_node("AnimationPlayer").play("appear")
	new_stuff()

func button_pressed(color: String):
	if get_node("Questions/" + color).get("text") == description[current_number]:
		print("good!")
		new_stuff()
	else:
		print("bad!")
		new_stuff()

func new_stuff():
	current_number += 1
	if current_number > terms.size() - 1:
		current_number = 0
	get_node("Term").set("text", terms[current_number])
	match terms.size():
		3:
			# hide nodes
			get_node("Questions/Purple").set_visible(false)
			get_node("Answers/Purple").set_visible(false)
			# refresh
			var rand = not_current_rand()
			get_node("Questions/Blue").set("text", description[rand])
			rand = not_current_rand()
			get_node("Questions/Green").set("text", description[rand])
			rand = not_current_rand()
			get_node("Questions/Red").set("text", description[rand])
			set_answer(1)
			return
		2:
			# hide nodes
			get_node("Questions/Purple").set_visible(false)
			get_node("Questions/Blue").set_visible(false)
			get_node("Answers/Purple").set_visible(false)
			get_node("Answers/Blue").set_visible(false)
			# refresh
			if randi_range(0, 1) == 0:
				get_node("Questions/Green").set("text", description[0])
				get_node("Questions/Red").set("text", description[1])
			else:
				get_node("Questions/Green").set("text", description[1])
				get_node("Questions/Red").set("text", description[0])
			return
		1:
			# hide nodes
			get_node("Questions/Purple").set_visible(false)
			get_node("Questions/Blue").set_visible(false)
			get_node("Questions/Red").set_visible(false)
			get_node("Answers/Purple").set_visible(false)
			get_node("Answers/Blue").set_visible(false)
			get_node("Answers/Red").set_visible(false)
			# refresh
			get_node("Questions/Green").set("text", description[0])
			return
	var rand = not_current_rand()
	get_node("Questions/Purple").set("text", description[rand])
	rand = not_current_rand()
	get_node("Questions/Blue").set("text", description[rand])
	rand = not_current_rand()
	get_node("Questions/Green").set("text", description[rand])
	rand = not_current_rand()
	get_node("Questions/Red").set("text", description[rand])
	set_answer(0)

func not_current_rand():
	var random = current_number
	while random == current_number:
		random = randi_range(0, terms.size() - 1)
	return random

func set_answer(subtract: int):
	var random = randi_range(1, 4) - subtract
	if random == 0:
		random = 1
	match random:
		4:
			get_node("Questions/Purple").set("text", description[current_number])
		3:
			get_node("Questions/Blue").set("text", description[current_number])
		2:
			get_node("Questions/Green").set("text", description[current_number])
		1:
			get_node("Questions/Red").set("text", description[current_number])

func Back():
	get_node("AnimationPlayer").play("disappear")
