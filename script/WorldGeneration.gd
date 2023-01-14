extends Node


signal return_card_data
signal return_world_data
signal new
signal color

var rng = RandomNumberGenerator.new()

var world_row_len = 5
var iq_chance = 1.0/4.0

var seed_value = 0


func mx(w):
	return 4 + w


func c():
	return rng.randi_range(2, 13)


func iq():
	return rng.randf() < iq_chance


func _rand_roll(c, n, m):
	var s = []
	for i in range(c):
		s.append(rng.randi_range(2, m))
	s.sort()
	return s[n]


func _rand_tile_num(w, h):
	var ii = 0
	ii += _rand_roll(5, h, 13)
	for i in range(w):
		ii += _rand_roll(5, h, 5)
	return ii


func _rand_reward(w, num):
	var cards = []
	for i in range(num):
		var value = c()
		cards.append({
			"value": value,
			"suit": rng.randi_range(1, mx(w))
		})
	return cards


func _rand_tile(w, h):
	var num = _rand_tile_num(w, h)
	var cards = []
	var suit = rng.randi_range(1, mx(w))
	for i in range(num):
		var value = c()
		if iq() and len(cards) > 0:
			suit = cards[rng.randi_range(0, len(cards)-1)].suit
		else:
			suit = rng.randi_range(1, mx(w))
		cards.append({
			"value": value,
			"suit": suit
		})
	var armories = {}
	var max_armory = w + 1
	for i in range(w*world_row_len+h):
		var avalue = c()
		var asuit
		if iq():
			asuit = cards[rng.randi_range(0, len(cards)-1)].suit
		else:
			asuit = rng.randi_range(1, mx(w))
		if not asuit in armories:
			armories[asuit] = []
		if len(armories[asuit]) < max_armory:
			armories[asuit].append(avalue)
	for k in armories:
		num += len(armories[k])
	return {
		"cards": cards,
		"armories": armories,
		"reward": _rand_reward(w, num)
	}


func new_game():
	randomize()
	seed_value = randi()
	rng.seed = seed_value

	var c = Color(rng.randf(),rng.randf(),rng.randf(),1).to_rgba32()
	emit_signal("color", c)

	var cards = []
	for i in range(10):
		cards.append({
			"value": c(),
			"suit": rng.randi_range(1,mx(0))
		})
	emit_signal("new")
	emit_signal("return_card_data", cards)
	return_new_world(0)


func return_new_world(n):
	emit_signal("return_world_data", new_world(n), n)


func new_world(w):
	if w > 5:
		return []
	var tiles = []
	var r = world_row_len
	var h = 0
	while r > 0:
		for i in range(r):
			tiles.append(_rand_tile(w, h))
		r -= 1
		h += 1
	return tiles
