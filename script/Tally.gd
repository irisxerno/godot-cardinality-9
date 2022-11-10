extends Node2D


signal done


func start_count(a, e):
	var ac = count(a)
	var ec = count(e)
	$Label.text = str(ac-ec)
	var c = 0
	if ac >= ec:
		c += 1
	if ec >= ac:
		c -= 1
	print(c)
	emit_signal("done", c)


static func count(deck):
	var s = Sort.to_suits(deck)
	print(s)
	var i = 0
	for k in s:
		var ii = 1
		for inst in s[k]:
			ii *= inst.value
		i += ii
	return i
