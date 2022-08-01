extends Node2D

var bars = []
var shape

export var gap = 5


func _ready():
	shape = $ColorRect
	$ColorRect.queue_free()


func set_bars(new_bar_count):
	if len(bars) == new_bar_count:
		return
	if len(bars) < new_bar_count:
		for i in range(new_bar_count-len(bars)):
			var new_bar = shape.duplicate()
			new_bar.rect_position += Vector2(len(bars)*(shape.rect_size.x+gap), 0)
			bars.append(new_bar)
			add_child(new_bar)


func count(n):
	for i in range(len(bars)):
		var bar = bars[i]
		bar.modulate = Color.black
		if i+1 > n:
			bar.modulate = Color.white
