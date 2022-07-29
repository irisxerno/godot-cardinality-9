extends Node

signal return_card_data
signal return_world_data

var rng = RandomNumberGenerator.new()

var world_row_len = 5
var iq_chance = 1/4

func _rand_roll(c, n):
	var s = []
	for i in range(c):
		s.append(rng.randi_range(2, 13))
	s.sort()
	return s[n]

func _rand_tile_num(w, h):
	var ii = 0
	ii += _rand_roll(5 + w, h + w)
	for i in range(w):
		ii += _rand_roll(5, h)
	return ii

func _rand_armories(w, h):
	var armories = {}
	var max_armory = w
	for i in range(w*world_row_len+h):
		var avalue = rng.randi_range(2, 13)
		var asuit = rng.randi_range(1, 4 + w)
		if not asuit in armories:
			armories[asuit] = []
		if len(armories[asuit]) < max_armory:
			armories[asuit].append({
				"value": avalue,
				"suit": asuit
			})

func _rand_tile(w, h):
	var num = _rand_tile_num(w, h)
	var cards = []
	var suit = rng.randi_range(1, 4 + w)
	for i in range(num):
		var value = rng.randi_range(2, 13)
		if rng.randf() > iq_chance:
			suit = rng.randi_range(1, 4 + w)
		cards.append({
			"value": value,
			"suit": suit
		})
	return {
		"cards": cards,
		"armories": _rand_armories(w, h)
	}

func new_game():
	randomize()
	rng.seed = randi()
	
	var cards = []
	for i in range(10):
		cards.append({
			"value": rng.randi_range(2,13),
			"suit": rng.randi_range(1,4)
		})
	emit_signal("return_card_data", cards)

	emit_signal("return_world_data", new_world(0))
	
func new_world(w):
	var tiles = []
	var r = world_row_len
	var h = 0
	while r > 0:
		for i in range(r):
			tiles.append(_rand_tile(w, h))
		r -= 1
		h += 1

func _ready():
	new_game()