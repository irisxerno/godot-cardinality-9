extends Node2D

export var mainhand = 5
export var offhand = 5
export var extra = 0
export var attack = 5
export var armory = 0

func _ready():
	pass # Replace with function body.

#func _process(delta):
#	pass

func add_card(inst):
	inst.connect("to_front", self, "to_front")
	call_deferred("add_child", inst)

func to_front(inst):
	move_child(inst, get_child_count())

func _on_DealController_request_return_cards(inst):
	var mainhand_curr = $MainhandController.count
	var offhand_curr = $OffhandController.count
	var take
	var dest
	if mainhand_curr < mainhand:
		take = mainhand - mainhand_curr
		dest = $MainhandController
	elif offhand_curr < offhand:
		take = offhand - offhand_curr
		dest = $OffhandController
	else:
		take = len(inst.cards)
		dest = $DealController
	var c = inst.cards.slice(max(len(inst.cards)-take,0), len(inst.cards)-1)
	inst.remove_cards(c)
	dest.update_cols(c)
