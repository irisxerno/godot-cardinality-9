extends Node


signal return_card_data
signal return_world_data
signal new
signal color

var rng = RandomNumberGenerator.new()
var iq_chance = 1.0/4.0

var world_seed = 0
var world_state = 0
var world_num = 0


func mx(w):
	return min(9, 4 + w)


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
		cards.append([c(), rng.randi_range(1, mx(w))])
	return cards


func _rand_tile(w, h):
	var num = _rand_tile_num(w, h)
	var cards = []
	var suit = rng.randi_range(1, mx(w))
	for i in range(num):
		var value = c()
		if len(cards) > 0 and iq():
			suit = cards[rng.randi_range(0, len(cards)-1)][1]
		else:
			suit = rng.randi_range(1, mx(w))
		cards.append([value, suit])
	var armories = {}
	var max_armory = w + 1
	for i in range(w*5+h):
		var avalue = c()
		var asuit
		if iq():
			asuit = cards[rng.randi_range(0, len(cards)-1)][1]
		else:
			asuit = rng.randi_range(1, mx(w))
		if not asuit in armories:
			armories[asuit] = []
		if len(armories[asuit]) < max_armory:
			armories[asuit].append(avalue)
	for k in armories:
		num += len(armories[k])
	return [cards, armories, _rand_reward(w, num)]


func new_game():
	randomize()
	world_seed = randi()
	rng.seed = world_seed

	var c = Color(rng.randf(),rng.randf(),rng.randf(),1).to_rgba32()
	emit_signal("color", c)

	emit_signal("new")

	var cards = []
	var cc = 10
	var cw = 0
	var cws = 0
	for i in range(cc):
		cards.append([c(),rng.randi_range(1,mx(cws))])
	emit_signal("return_card_data", cards)

	world_num = cw-1
	return_world(true)


func return_world(next=false):
	if next:
		world_state = rng.state
		world_num += 1
	else:
		rng.state = world_state
	emit_signal("return_world_data", new_world(world_num), world_num)


func new_world(w):
	if w > 5 or w < 0:
		return []
	var tiles = []
	var r = 5
	var h = 0
	while r > 0:
		for i in range(r):
			tiles.append(_rand_tile(w, h))
		r -= 1
		h += 1
	return tiles
