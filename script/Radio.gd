extends Control


var opts = []
signal selected


func _ready():
	for inst in get_children():
		if inst.get("text"):
			inst.radio = self
			opts.append(inst)


func select(si):
	var count = 0
	for inst in opts:
		if inst.visible:
			count += 1
	for inst in opts:
		if inst == si:
			inst.selected = true
			inst.update()
			if count < 2:
				inst.c()
			emit_signal("selected", inst.name)
		else:
			inst.selected = false
			inst.update()


