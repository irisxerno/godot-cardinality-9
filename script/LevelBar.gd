extends Node2D

var bars = []
var shape
var bar_count = 0
var num = 0

export var gap = 5


func _ready():
	shape = $ColorRect.duplicate()
	$ColorRect.queue_free()


func set_bars(new_bar_count):
	if len(bars) < new_bar_count:
		for i in range(new_bar_count-len(bars)):
			var new_bar = shape.duplicate()
			new_bar.rect_position += Vector2(len(bars)*(shape.rect_size.x+gap), 0)
			bars.append(new_bar)
			add_child(new_bar)

	for i in range(len(bars)):
		var bar = bars[i]
		bar.visible = false
		if i+1 <= new_bar_count:
			bar.visible = true
	bar_count = new_bar_count
	count(num)
	if has_node("Timer"):
		visible = true
		get_node("Timer").start()


func count(n):
	num = n
	for i in range(len(bars)):
		var bar = bars[i]
		bar.modulate = Color.black
		if i+1 > num:
			bar.modulate = Color.white


func hide():
	visible = false
