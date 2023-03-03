extends Control

@onready var animation = get_node("Background/AnimationPlayer")

func _ready():
	animation.play("Start")

func spin():
	animation.play("Spin")

func more_spin():
	animation.set_speed_scale(animation.get_speed_scale() * 0.92)
	if animation.get_speed_scale() >= 0.1:
		animation.play("More_Spin")
	else:
		animation.set_speed_scale(1)
		animation.play("Final_Spin")

func save_and_back():
	print("Good job! Now fuck off!")
	get_tree().change_scene_to_file("res://Scene/main_menu.tscn")
