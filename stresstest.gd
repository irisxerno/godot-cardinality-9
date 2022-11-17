extends Node2D


var scene = preload("res://scene/Card.tscn")
var cursor = Vector2(640,360)
var c = 0

var maxfps = 0


func _process(delta):
	var fps = Performance.get_monitor(Performance.TIME_FPS)
	if fps > maxfps:
		maxfps = fps
	$Debug.text = str(c) + " " + str(fps)
	if fps < maxfps:
		return


	var inst = scene.instance()
	inst.position = cursor
	inst.test = true
	inst.face_up = true
	cursor += Vector2(rand_range(-10,10),rand_range(-10, 10))
	add_child(inst)
	c += 1
