extends Node2D

export var mainhand = 5
export var offhand = 5
export var attack = 5

var stats = null
var armory = null


func _on_Deal_request_return_cards(inst):
	var mainhand = stats.get_mainhand()
	var offhand = stats.get_offhand()
	var attack = stats.get_attack()
	var mainhand_curr = $Mainhand.count
	var offhand_curr = $Offhand.count
	var take
	var dest
	var uselect = armory.find_selected()
	if uselect:
		take = 1
		dest = uselect
	elif mainhand_curr < mainhand:
		take = mainhand - mainhand_curr
		dest = $Mainhand
	elif offhand_curr < offhand:
		take = offhand - offhand_curr
		dest = $Offhand
	else:
		take = len(inst.cards)
		dest = $Deal
	if not dest == $Deal:
		take = min(take, attack)
	var c = inst.cards.slice(max(len(inst.cards)-take,0), len(inst.cards)-1)
	inst.remove_cards(c)
	if uselect:
		dest.give_card(c[0])
	else:
		dest.add_cards(c)


func update():
	for inst in get_children():
		if inst.has_method("update"):
			inst.update()


func clear():
	for inst in get_children():
		if inst.has_method("return_all"):
			inst.return_all()
