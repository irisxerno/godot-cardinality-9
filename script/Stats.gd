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
