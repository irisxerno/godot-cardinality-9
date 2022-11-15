extends Node2D


signal return_cards
signal add_armory

var slots = []
var count = 0

func find_selected():
	for inst in slots:
		if inst.selected:
			return inst
	return false


func kill_cards():
	for inst in slots:
		inst.kill()


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


func return_cards(cs):
	emit_signal("return_cards",cs)


func add_armory(cs):
	emit_signal("add_armory",cs)
