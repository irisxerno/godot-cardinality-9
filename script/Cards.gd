extends Node2D


var raise_counter = 0
var rcmax = 0


func _process(delta):
	if raise_counter > 0:
		if raise_counter > rcmax:
			rcmax = raise_counter
		if get_node("Debug"):
			$Debug.text = str(raise_counter)+"/"+str(rcmax)
	raise_counter = 0


func add_card(inst):
	inst.connect("to_front", self, "to_front")
	call_deferred("add_child", inst)


func to_front(inst):
	#move_child(inst, get_child_count())
	raise_counter += 1
	inst.raise()


func kill(all = false):
	for inst in get_children():
		if inst.has_method("kill"):
			if inst.death or all:
				inst.kill()
