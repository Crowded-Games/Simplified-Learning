extends Control

@onready var Animator = get_node("AnimationPlayer")
var scene_empty = false
var button_number = 0

func _ready():
	if !FileAccess.file_exists("res://settings.txt"):
		get_tree().change_scene_to_file("res://Scene/welcome.tscn")
	Animator.play("GetIn")

func button(number: int):
	button_number = number
	Animator.play("GetOut")
	scene_empty = true

func _process(_delta):
	if !Animator.is_playing() and scene_empty == true:
		match(button_number):
			1:
				get_tree().change_scene_to_file("res://Scene/studying_part.tscn")
			2:
				get_tree().change_scene_to_file("res://Scene/editor.tscn")
			3:
				get_tree().change_scene_to_file("res://Scene/settings.tscn")
			4:
				get_tree().quit()
			5:
				get_tree().change_scene_to_file("res://Scene/quiz_mode.tscn")
