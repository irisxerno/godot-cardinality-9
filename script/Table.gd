extends Node2D

export var mainhand = 5
export var offhand = 5
export var attack = 5


func _enter_tree():
	update_counts()


func update_counts():
	$Mainhand.max_count = mainhand
	$Offhand.max_count = offhand


func _on_Deal_request_return_cards(inst):
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


func update():
	for inst in get_children():
		if inst.has_method("update"):
			inst.update()


func clear():
	for inst in get_children():
		if inst.has_method("return_all"):
			inst.return_all()
