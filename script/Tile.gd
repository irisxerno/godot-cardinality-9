extends Control


signal request_select

var armories = {}
var cards = []
var reward = []

var selected = false
var state = "hide"

var row = -1
var col = -1


func _ready():
	var count = len(cards)
	$Label.text = str(count)
	var cursor = Vector2(0,0)
	var scenec = preload("res://scene/MiniCircle.tscn")
	var scener = preload("res://scene/MiniRect.tscn")
	var ic = []
	var ak = armories.keys()
	var acount = 0
	$Label.rect_position = Vector2(0,0)
	$Label2.text = ""
	ak.sort()
	for k in ak:
		for a in armories[k]:
			var inst = scenec.instance()
			var h = 1.0/9.0*(int(k)-1) + 0.5/9.0
			inst.modulate = Color.from_hsv(h, 0.6, 1)
			ic.append(inst)
			acount += 1
	if acount > 0:
		$Label.rect_position = Vector2(5,5)
		$Label2.text = str(acount)

	var cs = cards.duplicate()
	cs.sort_custom(Sort, "by_suit")
	for c in cs:
		var inst = scener.instance()
		var h = 1.0/9.0*(c[1]-1) + 0.5/9.0
		inst.modulate = Color.from_hsv(h, 0.6, 1)
		ic.append(inst)


	for inst in ic:
		inst.position = cursor*30+Vector2(15,15)
		$Peek.add_child(inst)
		cursor += Vector2(1, 0)
		if cursor.x >= 8:
			cursor.x = 0
			cursor.y += 1

	var i = len(ic)
	$Peek/Rect.rect_size = Vector2(min(8, i), ceil(i/8.0))*30
	update()


func update():
	$Background.modulate = Color(0, 0, 0, 0.5)
	$Peek.visible = false
	if selected:
		$Background.modulate = Color(1, 1, 1, 0.5)
		if state == "show":
			$Peek.visible = true
	$Defeated.visible = false
	$Background.visible = true
	$Label.visible = true
	$Label2.visible = true
	$Border.visible = true
	$Dot.visible = false
	visible = true
	if state != "show":
		$Label.visible = false
		$Label2.visible = false
		$Border.visible = false
	if state == "hide":
		$Dot.visible = true
		$Background.visible = false
	elif state == "defeated":
		$Defeated.visible = true
		$Background.visible = false


func advance_state():
	if state == "hide":
		state = "peek"
	elif state == "peek":
		state = "show"
	update()


func _on_gui_input(event):
	if (state == "show" or state == "peek") and event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		if selected:
			emit_signal("request_select", self)
		selected = !selected
		update()


func _input(event):
	if event is InputEventMouseButton and event.pressed and not Rect2(Vector2(), rect_size).has_point(get_local_mouse_position()) and selected:
		selected = false
		update()
