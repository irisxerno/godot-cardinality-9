extends Control


signal request_select

var armories = {}
var cards = []
var reward = []

var selected = false
var state = "hide"

var row = -1
var col = -1


func _ready():
	update()


func update():
	$Label.text = str(len(cards))
	$Background.modulate = Color(0, 0, 0, 0.5)
	if selected:
		$Background.modulate = Color(1, 1, 1, 0.5)
	$Defeated.visible = false
	$Background.visible = true
	$Label.visible = true
	$Border.visible = true
	$Dot.visible = false
	visible = true
	if state == "peek":
		$Label.visible = false
		$Border.visible = false
	if state == "hide":
		$Label.visible = false
		$Background.visible = false
		$Border.visible = false
		$Dot.visible = true
	elif state == "defeated":
		$Label.visible = false
		$Background.visible = false
		$Border.visible = false
		$Defeated.visible = true


func advance_state():
	if state == "hide":
		state = "peek"
	elif state == "peek":
		state = "show"
	update()


func _on_gui_input(event):
	if (state == "show" or state == "peek") and event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		if selected:
			emit_signal("request_select", self)
		selected = !selected
		update()


func _input(event):
	if event is InputEventMouseButton and event.pressed and not Rect2(Vector2(), rect_size).has_point(get_local_mouse_position()) and selected:
		selected = false
		update()
