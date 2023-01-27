extends Control


signal click
signal select

var selected = false
export var toggle = false


func update():
	var c = modulate
	c.a = 0.25
	if selected:
		c.a = 0.75
	modulate = c


func _on_gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		if selected:
			emit_signal("click")
		else:
			emit_signal("select")
		selected = !selected
		update()

func _input(event):
	if not toggle and event is InputEventMouseButton and event.pressed and not Rect2(Vector2(), rect_size).has_point(get_local_mouse_position()) and selected:
		selected = false
		update()
