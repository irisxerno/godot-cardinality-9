extends Control

signal return_cost
signal try_buy
signal update

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


func setl(l):
	$Tickmarks.reset()
	level = l
	update()


func update():
	$Level.text = str(level)
	$Cost.text = ""
	$Level.rect_position = Vector2(0,0)
	if cost() != level:
		$Level.rect_position = Vector2(-5, -5)
		$Cost.text = str(cost())
	emit_signal("update", level)


func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_LEFT:
			emit_signal("try_buy", self)
		elif event.button_index == BUTTON_RIGHT:
			$Tickmarks.decrease()
