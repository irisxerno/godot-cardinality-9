extends Node2D

var cards = []
var count = 0

export var step = Vector2(1,1)

export var move_vect = Vector2(0, 200)


func toggle():
	position -= move_vect
	move_vect *= -1
	update()


func add_cards(new_cards):
	cards.append_array(new_cards)
	update()


func remove_cards(rcs):
	var new_cards = []
	for c in cards:
		if not c in rcs:
			new_cards.append(c)
	cards = new_cards
	update()


func request_take_cards(inst):
	var new_cards = inst.cards
	inst.remove_cards(new_cards)
	add_cards(new_cards)


func cards():
	return cards


func count():
	return len(cards)


func update():
	var cursor = Vector2(0,0)
	for inst in cards:
		inst.face_up = false
		inst.move_to(self.position+cursor)
		cursor += step
	count = len(cards)


func return_all():
	return cards
	cards = []
