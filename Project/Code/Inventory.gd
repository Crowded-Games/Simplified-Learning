extends Control

@export var textures: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	if FileAccess.file_exists("res://Inventory.txt"):
		var file = FileAccess.open("res://Inventory.txt", FileAccess.READ)
		var line = file.get_line()
		while line != "":
			var thing = TextureRect.new()
			thing.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			thing.custom_minimum_size = Vector2(300, 300)
			thing.texture = textures[int(line) - 1]
			get_node("ScrollContainer/HFlowContainer").add_child(thing)
			line = file.get_line()

func Back():
	get_tree().change_scene_to_file("res://Scene/main_menu.tscn")
