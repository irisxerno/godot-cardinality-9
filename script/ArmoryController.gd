extends Node2D


signal add_card

var armories = {}

var step = Vector2(5, 5)


func deal_from_data(armory_data):
	armories = {}
	if len(armory_data) == 0:
		return
	var scene = preload("res://scene/Armory.tscn")
	for k in armory_data:
		armories[k] = []
		for d in armory_data[k]:
			var inst = scene.instance()
			inst.value = d
			inst.suit = k
			inst.position = self.position
			armories[k].append(inst)
			emit_signal("add_card", inst)
		armories[k].sort_custom(Sort, "by_value")
	call_deferred("update")


func update():
	var cursor = Vector2(0,0)
	var kl = -1
	for k in armories:
		for inst in armories[k]:
			inst.move_to(to_global($MoveTo.position+cursor))
			cursor += step
			kl = inst.suit
		cursor = Vector2(cursor.x+100, 0)


func list():
	var l = []
	for k in armories:
		for inst in armories[k]:
			l.append(inst)
	return l


func dict():
	return armories


func return_all():
	for inst in list():
		inst.move_to(to_global(inst.position+Vector2(0, -100)))
		inst.kill()
	armories = {}
	return
