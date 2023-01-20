extends Control


export var xp = 0

var score = 0
var progress = 0

var list
var shown_stats = 0

signal buy_pressed


func _ready():
	list = [$Mainhand, $Offhand, $Extra, $Attack, $Armory]
	update()


func update():
	$XP.text = str(xp)
	var i = 0
	for inst in list:
		inst.visible = false
		if i < shown_stats:
			inst.visible = true
		i += 1


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


func add_xp(i):
	score += i
	progress += 1
	print("score: ", score)
	return_cost(i)


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
		"attack": get_attack(),
		"armory": get_armory(),
		"score": score,
		"progress": progress,
	}


func from_data(sdata):
	xp = sdata["xp"]
	score = sdata["score"]
	progress = sdata["progress"]
	$Mainhand.setl(sdata["mainhand"])
	$Offhand.setl(sdata["offhand"])
	$Extra.setl(sdata["extra"])
	$Attack.setl(sdata["attack"])
	$Armory.setl(sdata["armory"])
	update()


func new():
	xp = 0
	score = 0
	progress = 0
	update()
	for inst in get_children():
		if inst.has_method("cost"):
			inst.get_node("Tickmarks").reset()
			inst.level = inst.default
			inst.update()


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
