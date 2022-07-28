extends Area2D

signal request_return_cards
signal update

var cards = []
var movex = 30
var movey = 2

export var count = -1

var base_shape

func _ready():
	base_shape = $CollisionShape2D.shape.duplicate()

func add_cards(cs):
	cards = cs
	cards.sort_custom(CardSort, "sort_by_value")
	update()

func update():
	var cursor = Vector2(0,0)
	for c in cards:
		c.move_to(to_global(cursor))
		cursor += Vector2(movex,movey)
	$CollisionShape2D.shape = base_shape.duplicate()
	$CollisionShape2D.shape.extents += Vector2(movex,movey)*(len(cards)-1)*0.5
	$CollisionShape2D.position = Vector2(movex,movey)*(len(cards)-1)*0.5

	if len(cards) > 0:
		input_pickable = true
		$CollisionShape2D.visible = true
	else:
		input_pickable = false
		$CollisionShape2D.visible = false # for Debug/Visible Collision Shapes

func _on_mouse_entered():
	pass

func _on_mouse_exited():
	pass

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		emit_signal("request_return_cards", self)

func remove_cards(rcs):
	var new_cards = []
	for c in cards:
		if not c in rcs:
			new_cards.append(c)
	cards = new_cards
	emit_signal("update")
