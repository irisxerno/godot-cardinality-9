extends Node2D

func _ready():
	pass # Replace with function body.

#func _process(delta):
#	pass

func _on_add_child(inst):
	call_deferred("add_child", inst)

func _on_return_cards(dest_str, cards):
	var dest = get_node_or_null(dest_str)
	if dest and dest.has_method("add_cards"):
		dest.call_deferred("add_cards", cards)
	else:
		for inst in cards:
			inst.move_to(Vector2(0,0))
		print("Destination %s not found, leaving %d cards as orphans" % [dest_str, len(cards)])
