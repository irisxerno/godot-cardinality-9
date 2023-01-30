extends Control


signal click

var selected = false
var radio
export var toggle = false


func _ready():
	update()

func update():
	c(selected)


func c(b=false):
	var c = modulate
	c.a = 0.25
	if b:
		c.a = 0.75
	modulate = c


func select(b):
	selected = b
	emit_signal("click", selected)
	update()


func _on_gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		if radio:
			radio.select(self)
		else:
			selected = !selected
			emit_signal("click", selected)
			update()

func _input(event):
	if not toggle and not radio and event is InputEventMouseButton and event.pressed and not Rect2(Vector2(), rect_size).has_point(get_local_mouse_position()) and selected:
		selected = false
		update()
