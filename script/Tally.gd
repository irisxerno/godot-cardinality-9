extends Node2D


signal done

var last_c
var all = []
var curr = []
var t = 0
var tt = 1.0/20.0


func _process(delta):
	if len(all) < 2:
		return
	t += delta
	if t < tt:
		return
	t -= tt
	if len(all[0]) > 0:
		curr[0].append(all[0].pop_front())
	if len(all[1]) > 0:
		curr[1].append(all[1].pop_front())
	var ac = count(curr[0])
	var ec = count(curr[1])
	last_c = ac-ec
	$Label.text = str(last_c)
	if len(all[0])+len(all[1]) == 0:
		all = []
		curr = []
		$CollisionShape2D.disabled = false
		$Indicator.visible = true
		$Indicator.modulate = Color(1, 1, 0, 0.25)
		if last_c > 0:
			$Indicator.modulate = Color(0, 1, 0, 0.25)
		if last_c < 0:
			$Indicator.modulate = Color(1, 0, 0, 0.25)


func filter(a, r, d):
	var kinds = []
	for inst in a:
		if not inst.suit in kinds:
			kinds.append(inst.suit)
	for inst in r:
		if inst.suit in kinds:
			a.append(inst)
	for inst in d:
		if inst.suit in kinds:
			a.append(inst)
	return a


func start_count(a, r, d, e, er, ed):
	all = [filter(a, r, ed), filter(e, er, d)]
	curr = [[],[]]
	t = 0
	update()


static func count(deck):
	var s = Sort.to_suits(deck)
	var i = 0
	for k in s:
		var ii = 1
		for inst in s[k]:
			if inst.diamond:
				print("NAPKIN!!!")
				ii /= inst.value
			else:
				ii *= inst.value
		i += ii
	return i


func clear(death=false):
	$CollisionShape2D.disabled = true
	$Label.text = "0"
	$Indicator.visible = false


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		$CollisionShape2D.disabled = true
		emit_signal("done", last_c)
		$Label.text = "0"
		$Indicator.visible = false
