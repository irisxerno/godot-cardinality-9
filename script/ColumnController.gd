extends Area2D

signal return_cards

var cards
var movex = 30
var movey = 2

func add_cards(cs):
	cards = cs
	cards.sort_custom(CardSort, "sort_by_value")

	var cursor = Vector2(0,0)
	for c in cards:
		c.move_to(to_global(cursor))
		cursor += Vector2(movex,movey)
	$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate()
	$CollisionShape2D.shape.extents += Vector2(movex,movey)*(len(cards)-1)*0.5
	$CollisionShape2D.position += Vector2(movex,movey)*(len(cards)-1)*0.5

func _on_mouse_entered():
	pass

func _on_mouse_exited():
	pass

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		return_cards()

func return_cards():
	emit_signal("return_cards", cards)
	queue_free()
