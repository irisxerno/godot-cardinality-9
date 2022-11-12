extends Control

export var xp = 0


func _ready():
	update()


func update():
	$XP.text = str(xp)


func try_buy(inst):
	var cost = inst.cost()
	if xp >= cost:
		xp -= cost
		inst.increase()
		update()


func return_cost(i):
	xp += i
	update()


func reset_ticks():
	for inst in get_children():
		if inst.has_method("cost"):
			inst.get_node("Tickmarks").reset()


func get_mainhand():
	return $Mainhand.level
func get_offhand():
	return $Offhand.level
func get_extra():
	return $Extra.level
func get_attack():
	return $Attack.level
func get_armory():
	return $Armory.level
