extends Area2D


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


func _on_input_event(viewport, event, shape_idx):
	if state == "show" and event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		emit_signal("request_select",  self)
