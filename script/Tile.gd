extends Control


signal request_select

var armories = {}
var cards = []

var selected = false
var state = "show"


func _ready():
	update()


func update():
	$Label.text = str(len(cards))
	$Background.modulate = Color(0, 0, 0, 0.5)
	if selected:
		$Background.modulate = Color(1, 1, 1, 0.5)
	$Defeated.visible = false
	self.visible = true
	if self.state == "hide":
		self.visible = false
	elif self.state == "defeated":
		$Background.visible = false
		$Border.visible = false
		$Defeated.visible = true


func _on_gui_input(event):
	if state == "show" and event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		if selected:
			emit_signal("request_select", self)
		selected = !selected
		update()


func _input(event):
	if event is InputEventMouseButton and event.pressed and not Rect2(Vector2(), rect_size).has_point(get_local_mouse_position()) and selected:
		selected = false
		update()
