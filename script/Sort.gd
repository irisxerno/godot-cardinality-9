extends Node

static func by_value(a, b):
	if a.value < b.value:
		return true
	return false

static func to_suits(things):
	var by_suits = {}
	for c in things:
		if not c.suit in by_suits:
			by_suits[c.suit] = []
		by_suits[c.suit].append(c)
	return by_suits
