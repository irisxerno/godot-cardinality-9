extends Node


static func by_value(a, b):
	if get_value(a) < get_value(b):
		return true
	return false


static func get_value(a):
	var avl
	if typeof(a) == TYPE_ARRAY:
		avl = a[0]
	else:
		avl = a.value
	return avl


static func get_suit(a):
	var asu
	if typeof(a) == TYPE_ARRAY:
		asu = a[1]
	else:
		asu = a.suit
	return asu


static func by_suit(a, b):
	if get_suit(a) < get_suit(b):
		return true
	return false



static func to_suits(things):
	var by_suits = {}
	for c in things:
		var cs = get_suit(c)
		if not cs in by_suits:
			by_suits[cs] = []
		by_suits[cs].append(c)
	return by_suits
