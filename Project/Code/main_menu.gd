extends Control

func _on_start_pressed():
	get_tree().change_scene_to_file("res://Scene/studying_part.tscn")

func _on_editor_pressed():
	get_tree().change_scene_to_file("res://Scene/editor.tscn")

func _on_settings_pressed():
	get_tree().change_scene_to_file("res://Scene/settings.tscn")

func _on_quit_pressed():
	get_tree().quit()
