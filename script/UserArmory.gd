extends Node2D


signal return_cards
signal add_armory

var slots = []
var count = 0


func new():
	for inst in slots:
		if inst.armory:
			inst.armory.kill()
			inst.armory = null
		if inst.backup_armory:
			inst.backup_armory.kill()
			inst.backup_armory = null
		if inst.card:
			inst.card.kill()
			inst.card = null
	set_slots(0)


func find_selected():
	for inst in slots:
		if inst.selected:
			return inst
	return false


func kill_cards():
	for inst in slots:
		inst.kill()
	# TODO: i might want to setup a reordering job to avoid inconsistency with save


func set_slots(new_slot_count):
	count = new_slot_count
	var scene = preload("res://scene/Slot.tscn")
	if len(slots) < count:
		for i in range(count-len(slots)):
			var new_slot = scene.instance()
			new_slot.rect_position += Vector2(-len(slots)*(96), 0)
			slots.append(new_slot)
			new_slot.connect("return_cards", self, "return_cards")
			new_slot.connect("add_armory", self, "add_armory")
			add_child(new_slot)

	for i in range(len(slots)):
		var slot = slots[i]
		slot.visible = false
		if i+1 <= count:
			slot.visible = true
		else:
			slot.clear()


func list():
	var armories = []
	for inst in slots:
		if inst.armory:
			armories.append(inst.armory)
	return armories


func dict():
	var dict = {}
	for s in slots:
		var inst = s.armory
		if not inst:
			continue
		if not inst.suit in dict:
			dict[inst.suit] = []
		dict[inst.suit].append(inst)
	return dict


func to_data():
	var armory_data = []
	for s in slots:
		var inst = s.armory
		var a = null
		if inst:
			a = {
				"value": inst.value,
				"suit": inst.suit
			}
		armory_data.append(a)
	return armory_data


func from_data(adata):
	new()
	set_slots(len(adata))
	for i in range(len(adata)):
		var inst = slots[i]
		var ad = adata[i]
		if ad:
			inst.new_armory(ad["value"], int(ad["suit"]))
			inst.backup_armory = inst.armory


func return_cards(cs):
	emit_signal("return_cards",cs)


func add_armory(cs):
	emit_signal("add_armory",cs)
