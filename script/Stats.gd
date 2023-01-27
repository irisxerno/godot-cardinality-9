extends Control


export var xp = 0

var score = 0
var progress = 0

var list
var unlocked = 0
var criteria = [5, 10, 15, 40, 65, 115]

signal buy_pressed


func _ready():
	list = [$Mainhand, $Offhand, $Extra, $Armory, $Diamond, $Attack]
	update()


func update():
	$XP.text = str(xp)
	var i = 0
	for inst in list:
		inst.visible = false
		if i < unlocked:
			inst.visible = true
			if inst.cost() <= xp and inst.level < inst.maxval:
				inst.set_purchasable(true)
			else:
				inst.set_purchasable(false)
		i += 1
		inst.update()


func try_buy(inst):
	var cost = inst.cost()
	if xp >= cost and inst.level < inst.maxval:
		emit_signal("buy_pressed")
		xp -= cost
		inst.increase()
		update()


func return_cost(i):
	xp += i
	update()


func add_xp(i, p=1):
	score += i
	progress += p
	progress_stats()
	print("score: ", score)
	return_cost(i)


func progress_stats():
	if unlocked > (len(criteria) - 1):
		return
	if score >= criteria[unlocked]:
		unlocked += 1
		update()
		

func reset_ticks():
	for inst in get_children():
		if inst.has_method("cost"):
			inst.get_node("Tickmarks").reset()


func to_data():
	return {
		"xp": xp,
		"mainhand": get_mainhand(),
		"offhand": get_offhand(),
		"extra": get_extra(),
		"armory": get_armory(),
		"diamond": get_diamond(),
		"attack": get_attack(),
		"score": score,
		"progress": progress,
		"unlocked": unlocked,
	}


func from_data(sdata):
	xp = sdata["xp"]
	score = sdata["score"]
	progress = sdata["progress"]
	unlocked = sdata["unlocked"]
	$Mainhand.setl(sdata["mainhand"])
	$Offhand.setl(sdata["offhand"])
	$Extra.setl(sdata["extra"])
	$Attack.setl(sdata["attack"])
	$Armory.setl(sdata["armory"])
	$Diamond.setl(sdata["diamond"])
	update()


func new():
	xp = 0
	score = 0
	progress = 0
	unlocked = 0
	for inst in get_children():
		if inst.has_method("cost"):
			inst.get_node("Tickmarks").reset()
			inst.level = inst.default
	update()


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
func get_diamond():
	return $Diamond.level

func _on_debug():
	xp = 1000
	unlocked = len(criteria)
	$Mainhand.level = 10
	$Offhand.level = 10
	update()
