extends Control


var lines = []
var linelen = 0
var tick = false
var fade = false
var t = 0
export var tick_dur = 0.2


func _ready():
	visible = false


func start(rng_seed):
	print(rng_seed)
	var file = File.new()
	file.open("res://lines", File.READ)
	for i in range(100):
		lines.append(file.get_line())
	file.close()
	var rng = RandomNumberGenerator.new()
	#rng.randomize()
	rng.seed = rng_seed
	var line = lines[rng.randi_range(0,len(lines)-1)]
	$Label.visible = true
	$Label.text = line
	$Label.visible_characters = 0
	linelen = len($Label.text)
	visible = true
	tick = false
	fade = false
	$Timer.start()


func _on_timeout():
	if fade:
		$AlphaTween.interpolate_property($Label, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 10, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$AlphaTween.start()
	tick = true


func _process(delta):
	if tick:
		t += delta
		if t > tick_dur:
			t -= tick_dur
			if $Label.visible_characters < linelen:
				$Label.visible_characters += 1
			elif not fade:
				fade = true
				$Timer.start()


func _on_gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		if tick and not fade:
			print("skip")
			fade = true
			_on_timeout()
