extends Control


func update_all(new_state, tween=true):
	for inst in get_children():
		if inst.has_method("update_state"):
			inst.update_state(new_state, tween)
