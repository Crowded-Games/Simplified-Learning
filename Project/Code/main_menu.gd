extends Control

@onready var Animator = get_node("AnimationPlayer")
var scene_empty = false
var button_number = 0

@onready var Date = Time.get_date_dict_from_system()

func _ready():
	if !FileAccess.file_exists("res://settings.txt"):
		get_tree().change_scene_to_file("res://Scene/welcome.tscn")
	Animator.play("GetIn")
	
	if FileAccess.file_exists("res://Date.txt"):
		var file = FileAccess.open("res://Date.txt", FileAccess.READ)
		var day = file.get_line()
		if (Date.day > int(day)) || (Date.day == 0 && int(day) != 0):
			print("Hey, give this man a daily award!")
			file = null
			file = FileAccess.open("res://Date.txt", FileAccess.WRITE)
			file.store_line(str(Date.day))
	else:
		var file = FileAccess.open("res://Date.txt", FileAccess.WRITE)
		file.store_line(str(Date.day))

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
