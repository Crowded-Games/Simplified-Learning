extends Control

@export var words: PackedStringArray

func save_setting():
	var file = FileAccess.open("res://settings.txt", FileAccess.WRITE)
	# I opted to use line since it makes it easier to get strings, ints, floats, and others
	file = null
