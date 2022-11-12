extends Control

signal decrease

var shape
var ticks = []

var count = 0


func _ready():
	shape = $Tick
	remove_child(shape)


func increase():
	count += 1
	update()


func decrease():
	if count >= 1:
		count -= 1
		update()
		emit_signal("decrease")

func update():
	while len(ticks) < count:
		var s = shape.duplicate()
		s.rect_position += Vector2(-5, 0)*len(ticks)
		ticks.append(s)
		add_child(s)
	for i in range(len(ticks)):
		var tick = ticks[i]
		tick.visible = true
		if i+1 > count:
			tick.visible = false


func reset():
	count = 0
	update()


func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_LEFT or event.button_index == BUTTON_RIGHT:
			decrease()
