extends Node2D


signal done

var last_c


func start_count(a, e):
	var ac = count(a)
	var ec = count(e)
	last_c = ac-ec
	$Label.text = str(last_c)
	$CollisionShape2D.disabled = false


static func count(deck):
	var s = Sort.to_suits(deck)
	var i = 0
	for k in s:
		var ii = 1
		for inst in s[k]:
			ii *= inst.value
		i += ii
	return i


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:

		$CollisionShape2D.disabled = true
		emit_signal("done", last_c)
		$Label.text = "0"
