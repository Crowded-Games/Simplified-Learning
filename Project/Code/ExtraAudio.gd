extends AudioStreamPlayer

@export var AutoLoop = false

func _process(delta):
	if self.playing == false && AutoLoop == true:
		self.play()
