extends Control

var state = "hide"

export var open_distance = 300
export var close_distance = 0
export var property = "margin_top"

func update_state(new_state):
	$Button.mouse_filter = MOUSE_FILTER_PASS
	var dest_dist = close_distance
	if new_state == "open":
		dest_dist = open_distance
	$Tween.interpolate_property(self, property, get(property), dest_dist, 0.5, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()
	state = new_state

func press():
	if $Tween.is_active():
		return
	var new_state = "open"
	if state == "open":
		new_state = "close"
	update_state(new_state)

func _on_gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		press()
