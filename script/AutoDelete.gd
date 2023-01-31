extends Node

var t = 0

func _process(delta):
	t += delta
	if t > 2:
		queue_free()
