extends Control

signal return_cost
signal try_buy

export var default = 0
export var base = 0
export var mult = 0

var level = 0


func _ready():
	level = default
	update()


func cost():
	return (level + base) * mult


func decrease():
	level -= 1
	update()
	emit_signal("return_cost", cost())


func increase():
	level += 1
	$Tickmarks.increase()
	update()


func update():
	$Level.text = str(level)
	if cost() != level:
		$Cost.text = str(cost())


func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_LEFT:
			emit_signal("try_buy", self)
		elif event.button_index == BUTTON_RIGHT:
			$Tickmarks.decrease()
