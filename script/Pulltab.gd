extends Control

signal set_input
signal request_press

signal open
signal close


var state = "close"

export var open_distance = 120
export var close_distance = 0
export var hide_distance = -100
export var property = "margin_top"


func update_state(new_state):
	var dest_dist = close_distance
	if new_state == "open":
		dest_dist = open_distance
		emit_signal("open")
	elif new_state == "hide":
		dest_dist = hide_distance
		emit_signal("close")
	$Tween.interpolate_property(self, property, get(property), dest_dist, 0.5, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()
	state = new_state


func _on_gui_input(event):
	if !$Tween.is_active() and event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		if state == "open":
			update_state("close")
		elif state == "close":
			update_state("open")
