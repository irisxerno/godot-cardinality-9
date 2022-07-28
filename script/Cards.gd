extends Node2D

func add_card(inst):
	inst.connect("to_front", self, "to_front")
	call_deferred("add_child", inst)

func to_front(inst):
	move_child(inst, get_child_count())
