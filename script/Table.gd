extends Node2D

func _ready():
	pass # Replace with function body.

#func _process(delta):
#	pass

func add_card(inst):
	inst.connect("to_front", self, "to_front")
	call_deferred("add_child", inst)

func to_front(inst):
	move_child(inst, get_child_count())

func return_cards(cds):
	for c in cds:
		c.queue_free()
