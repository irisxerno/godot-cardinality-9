extends Node2D


signal request_return_cards
signal dump

var column_controller_scene = preload("res://scene/ColumnController.tscn") 
var movex = 110
var cols = []

var count = 0

var level_bar

export var move_vect = Vector2(0, -200)


func toggle():
	position -= move_vect
	move_vect *= -1
	update()


func _ready():
	if has_node("LevelBar"):
		level_bar = get_node("LevelBar")


func update():
	add_cards([])


func cards():
	var cards = []

	for inst in cols:
		cards.append_array(inst.cards)

	return cards


func count():
	return count


func return_all():
	var cards = []

	for inst in cols:
		cards.append_array(inst.cards)
		inst.cards = []

	return cards


func clear(death=false):
	for inst in cols:
		for ins in inst.cards:
			ins.death = death
		inst.cards = []


func add_cards(new_cards):
	var cards = []

	for inst in cols:
		cards.append_array(inst.cards)
		inst.cards = []
		inst.update()

	cards.append_array(new_cards)
	count = len(cards)
	
	for inst in cards:
		inst.face_up = true
		inst.death = false
		inst.update()
	
	var by_suits = Sort.to_suits(cards)

	var cursor = Vector2(0,0)
	var colc = 0
	for suit in by_suits.keys():
		var cc
		if len(cols) < colc+1:
			cc = column_controller_scene.instance()
			add_child(cc)
			cols.append(cc)
			cc.connect("request_return_cards", self, "_request_return_cards")
			cc.connect("update", self, "update")
		else:
			cc = cols[colc]

		cc.position = cursor
		cc.add_cards(by_suits[suit])
		cursor += Vector2(movex, 0)
		cursor += Vector2(cc.movex*(len(by_suits[suit])-1),0)
		colc += 1
	if level_bar:
		level_bar.count(count)


func _request_return_cards(inst):
	emit_signal("request_return_cards", inst)


func request_take_cards(inst):
	var new_cards = inst.cards
	inst.remove_cards(new_cards)
	add_cards(new_cards)


func limit(n):
	var cards = return_all()
	var ret = []
	var ii = len(cards) - n
	if ii > 0:
		for i in range(ii):
			ret.append(cards.pop_back())
	add_cards(cards)
	emit_signal("dump", ret)


func pop_col(inst):
	breakpoint
	request_take_cards(inst)
