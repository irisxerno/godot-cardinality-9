extends Control


signal load_save

var selected
var index


func set_save(save, i):
	$Label.text = "w%d#%d+%d" % [save["world_num"], save["stats"]["progress"], save["stats"]["score"]]
	var c = Color(int(save["color"]))
	c.a = 0.25
	$Panel.modulate = c
	index = i


func update():
	var c = $Panel.modulate
	c.a = 0.25
	if selected:
		c.a = 0.75
	$Panel.modulate = c


func _on_gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		if selected:
			emit_signal("load_save", index)
		selected = !selected
		update()


func _input(event):
	if event is InputEventMouseButton and event.pressed and not Rect2(Vector2(), rect_size).has_point(get_local_mouse_position()) and selected:
		selected = false
		update()

