extends Node2D

signal return_cards

var cards = []
var column_controller_scene = preload("res://scene/ColumnController.tscn") 
var movex = 110

func _ready():
	pass # Replace with function body.

#func _process(delta):
#	pass

func add_cards(cds):
	self.cards.append_array(cds)
	update_cols()

func update_cols():
	for inst in get_children():
		inst.queue_free()
	
	var by_suits = {}
	for c in cards:
		if not c.suit in by_suits:
			by_suits[c.suit] = []
		by_suits[c.suit].append(c)

	var cursor = Vector2(0,0)
	for suit in by_suits.keys():
		var cc = column_controller_scene.instance()
		add_child(cc)
		cc.connect("return_cards", self, "return_cards")
		cc.position = cursor
		cc.add_cards(by_suits[suit])
		cursor += Vector2(movex, 0)
		cursor += Vector2(cc.movex*(len(by_suits[suit])-1),0)

func return_cards(cds):
	emit_signal("return_cards", cds)
	var new_cards = []
	for c in cards:
		if not c in cds:
			new_cards.append(c)
	cards = new_cards
	update_cols()
	
		
