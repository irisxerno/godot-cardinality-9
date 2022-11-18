extends Node2D


var scene = preload("res://scene/Card.tscn")
var cursor = Vector2(1280*(2.0/3.0),720*(2.0/3.0))
var c = 0
var t = 0

var maxfps = 59.9


func _process(delta):
	var fps = 1/delta
	# var fps = Performance.get_monitor(Performance.TIME_FPS)
	$Debug.text = str(c) + " " + str(fps)

	if fps < maxfps:
		t += delta
		return

	if t > 1:
		return

	t = 0

	var inst = scene.instance()
	inst.position = cursor
	inst.test = true
	inst.face_up = true
	cursor += Vector2(rand_range(-10,10),rand_range(-10, 10))
	add_child(inst)
	c += 1
