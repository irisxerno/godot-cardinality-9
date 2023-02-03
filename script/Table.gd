extends Node2D

signal uselect

export var mainhand = 5
export var offhand = 5
export var attack = 5

var stats
var armory
var diamond

func _on_Deal_request_return_cards(inst):
	if uselect(inst):
		return
	var mainhand = stats.get_mainhand()
	var offhand = stats.get_offhand()
	var attack = stats.get_attack()
	var mainhand_curr = $Mainhand.count
	var offhand_curr = $Offhand.count
	var take
	var dest

	if mainhand_curr < mainhand:
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
	dest.add_cards(c)


func uselect(inst):
	var u = 3
	var b = armory.find_selected()
	if not b:
		u = 4
		b = diamond.find_selected()
	if b:
		var c = inst.cards.back()
		inst.remove_cards([c])
		b.give_card(c)
		emit_signal("uselect", u)
		return true
	return false


func update():
	for inst in get_children():
		if inst.has_method("update"):
			inst.update()


func clear(death=false):
	for inst in get_children():
		if inst.has_method("clear"):
			inst.clear(death)

func request_take(inst):
	if uselect(inst):
		return
	$Deal.request_take_cards(inst)
