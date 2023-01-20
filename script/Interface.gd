extends Control


func _ready():
	visible = true


func update_all(new_state, tween=true):
	for inst in get_children():
		if inst.has_method("update_state"):
			inst.update_state(new_state, tween)


func show_tab(name):
	get_node(name).update_state("close")
