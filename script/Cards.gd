extends Node2D


func add_card(inst):
	inst.connect("to_front", self, "to_front")
	call_deferred("add_child", inst)


func to_front(inst):
	move_child(inst, get_child_count())


func mark_death():
	for inst in get_children():
		inst.death = true


func kill():
	for inst in get_children():
		if inst.death:
			inst.kill()
