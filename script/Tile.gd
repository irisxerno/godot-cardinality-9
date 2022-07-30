extends Area2D

var armories = {}
var cards = []

var selected = false
var state = "hide"

var input = false
func set_input(b):
	input = b
	modulate.a = 1 if b else 0.5

func _ready():
	update()

func update():
	$Label.text = str(len(cards))
	$Background.modulate = Color(0, 0, 0, 0.5)
	if selected:
		$Background.modulate = Color(1, 1, 1, 0.5)
	if self.state == "hide":
		self.visible = false
	elif self.state == "show":
		self.visible = true
	elif self.state == "defeated":
		self.visible = true
		$Background.visible = false
		$Border.visible = false
		$Defeated.visible = false

func _on_input_event(viewport, event, shape_idx):
	if input and state == "show" and event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		selected = !selected
		update()
