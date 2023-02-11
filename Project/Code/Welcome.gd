extends Node

@export_node_path("Button") var Continue
@export_node_path("RichTextLabel") var Text
@export var words: PackedStringArray

@onready var Animator = get_node("AnimationPlayer")

var current_array = 0

# start by having the text appear
func _ready():
	get_node(Text).set_text(words[current_array])
	Animator.play("appear")

# Makes the text go bye bye
func _on_agree_button_pressed():
	Animator.play("disappear")

# Once the text is done being textual, start the short quiz.
func Change_Text():
	current_array += 1
	if words.size() < current_array - 1:
		get_node(Text).set_text(words[current_array])
		Animator.play("appear")
	else:
		print("done!")
