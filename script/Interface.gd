extends Control

signal tab

var state = "hide"

var input = false
func set_input(b):
	for inst in get_children():
		if inst.has_method("set_input"):
			inst.set_input(b)

func _enter_tree():
	set_input(false)

func show():
	update_state("close")

func update_state(s):
	for inst in get_children():
		inst.update_state(s)

func _on_request_press(inst):
	if inst.state == "close":
		for inst2 in get_children():
			if inst2.has_method("update_state"):
				inst2.update_state("close")
		inst.update_state("open")
		emit_signal("tab", true)
	elif inst.state == "open":
		inst.update_state("close")
		emit_signal("tab", false)
		
