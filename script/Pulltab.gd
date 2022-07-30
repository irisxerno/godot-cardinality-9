extends Control

signal request_press

var state = "hide"

export var open_distance = 120
export var close_distance = 0
export var hide_distance = -100
export var property = "margin_top"

var input = false
func set_input(b):
	input = b

func _ready():
	set(property, hide_distance)
	update_state("hide")

func update_state(new_state):
	var dest_dist = close_distance
	if new_state == "open":
		dest_dist = open_distance
	elif new_state == "hide":
		dest_dist = hide_distance
	$Tween.interpolate_property(self, property, get(property), dest_dist, 0.5, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()
	state = new_state

func _on_gui_input(event):
	if input and !$Tween.is_active() and event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		emit_signal("request_press", self)
