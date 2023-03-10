extends AudioStreamPlayer

@export var AutoLoop = false

func _process(_delta):
	if self.playing == false && AutoLoop == true:
		self.play()
