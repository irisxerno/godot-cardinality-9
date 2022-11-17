extends Control


signal load_save

var saves = []


func _ready():
	var cursor = Vector2(0,0)
	var scene = preload("res://scene/Save.tscn")
	for i in range(5):
		var inst = scene.instance()
		inst.rect_position = cursor
		inst.visible = false
		inst.connect("load_save", self, "load_save")
		saves.append(inst)
		add_child(inst)
		cursor += Vector2(0, 90)


func load_save(index):
	emit_signal("load_save", index)


func set_saves(save_data):
	for i in range(len(save_data)):
		var save = save_data[-1-i]
		var inst = saves[i]
		inst.set_save(save, len(save_data)-i-1)
		inst.visible = true
