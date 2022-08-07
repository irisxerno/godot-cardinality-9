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


var mouse_entered = false


func _on_mouse_entered():
	mouse_entered = true

func _on_mouse_exited():
	mouse_entered = false


func _on_gui_input(event):
	if state == "show" and event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		mouse_entered = true
		selected = !selected
		update()


func _input(event):
	if event is InputEventMouseButton and event.pressed and !mouse_entered and selected:
		selected = false
		update()
