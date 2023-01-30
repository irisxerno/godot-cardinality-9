extends Control


signal set_input
signal request_press

signal click
signal new_state
signal trans_state

var state = "close"

export var open_distance = 120
export var close_distance = 0
export var hide_distance = -100
export var property = "margin_top"


func update_state(new_state, tween=true, force=false):
	var dest_dist = close_distance
	if new_state == "close" and not $Button.visible:
		new_state = "open"
	if new_state == "open" and $Background.visible:
		dest_dist = open_distance
	elif new_state == "hide":
		dest_dist = hide_distance
	if not $Background.visible and new_state == "close" and not force:
		return
	if not tween:
		self.set(property, dest_dist)
	else:
		$Tween.interpolate_property(self, property, get(property), dest_dist, 0.5, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		$Tween.start()
	state = new_state
	emit_signal("new_state", state)


func _on_gui_input(event):
	if !$Tween.is_active() and event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		if state == "open":
			update_state("close")
		elif state == "close":
			if not $Background.visible:
				update_state("hide")
				emit_signal("click")
			else:
				update_state("open")


func force_show():
	update_state("close", true, true)


func _on_tween_all_completed():
	emit_signal("trans_state", state)
