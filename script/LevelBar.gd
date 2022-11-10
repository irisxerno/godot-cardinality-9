extends Node2D

var bars = []
var shape

export var gap = 5


func _ready():
	shape = $ColorRect.duplicate()
	$ColorRect.queue_free()


func set_bars(new_bar_count):
	# TODO: Implement a blinking one: if it has Timer it should turn itself off
	# Would be used to visualize Stats/Attack
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


func count(n):
	for i in range(len(bars)):
		var bar = bars[i]
		bar.modulate = Color.black
		if i+1 > n:
			bar.modulate = Color.white
