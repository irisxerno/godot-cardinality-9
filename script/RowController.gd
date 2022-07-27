extends Node2D

signal request_return_cards

var column_controller_scene = preload("res://scene/ColumnController.tscn") 
var movex = 110

var count = 0

var cols = []

func _ready():
	pass # Replace with function body.

func update():
	update_cols([])

func update_cols(new_cards):
	var cards = []
	
	for inst in cols:
		cards.append_array(inst.cards)
		inst.cards = []
		inst.update()
		
	cards.append_array(new_cards)
	count = len(cards)
	
	var by_suits = {}
	for c in cards:
		if not c.suit in by_suits:
			by_suits[c.suit] = []
		by_suits[c.suit].append(c)

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

func _request_return_cards(inst):
	emit_signal("request_return_cards", inst)

func request_take_cards(inst):
	var new_cards = inst.cards
	inst.remove_cards(new_cards)
	update_cols(new_cards)

func pop_col(inst):
	breakpoint
	request_take_cards(inst)
