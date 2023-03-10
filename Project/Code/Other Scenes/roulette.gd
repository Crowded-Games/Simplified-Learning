extends Control

@onready var animation = get_node("Background/AnimationPlayer")
var ItemGained = 0
var MaxItems = 5
@export var textures: Array

func _ready():
	ItemGained = randi_range(1, MaxItems)
	get_node("Background/AudioStreamPlayer").play()
	animation.play("Start")

func spin():
	animation.play("Spin")

func add_images(starting: int):
	var number = starting
	while number != 5:
		var node = get_node("Spinner/Image" + str(number))
		node.set("texture", textures[randi_range(0, MaxItems - 1)])
		number += 1

func more_spin():
	animation.set_speed_scale(animation.get_speed_scale() * 0.90)
	get_node("Spinner/Image-3").set("texture", get_node("Spinner/Image1").get("texture"))
	get_node("Spinner/Image-2").set("texture", get_node("Spinner/Image2").get("texture"))
	get_node("Spinner/Image-1").set("texture", get_node("Spinner/Image3").get("texture"))
	get_node("Spinner/Image0").set("texture", get_node("Spinner/Image4").get("texture"))
	if animation.get_speed_scale() >= 0.05:
		animation.play("More_Spin")
	else:
		animation.set_speed_scale(1)
		get_node("Spinner/Image1").set("texture", textures[ItemGained - 1])
		animation.play("Final_Spin")

func save():
	get_node("End Screen/Item").set("texture", textures[ItemGained - 1])
	if (FileAccess.file_exists("res://Inventory.txt")):
		var file = FileAccess.open("res://Inventory.txt", FileAccess.READ_WRITE)
		while file.get_line() != "":
			pass # Don't worry about this :D
		file.store_line(str(ItemGained))
	else:
		var file = FileAccess.open("res://Inventory.txt", FileAccess.WRITE)
		file.store_line(str(ItemGained))
	get_node("End Screen").set_visible(true)

func claim():
	animation.play("Leave")

func back():
	get_tree().change_scene_to_file("res://Scene/main_menu.tscn")
