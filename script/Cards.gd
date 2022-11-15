extends Node2D


var raise_counter = 0


func _process(delta):
	if raise_counter > 0:
		if get_node("Debug"):
			$Debug.text = str(raise_counter)
	raise_counter = 0


func add_card(inst):
	inst.connect("to_front", self, "to_front")
	call_deferred("add_child", inst)


func to_front(inst):
	#move_child(inst, get_child_count())
	raise_counter += 1
	inst.raise()


func mark_death():
	for inst in get_children():
		if inst.has_method("update_face"):
			inst.death = true


func kill():
	for inst in get_children():
		if inst.has_method("kill") and inst.death:
			inst.kill()
