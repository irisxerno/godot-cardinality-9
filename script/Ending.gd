extends Control


var lines = []
var linelen = 0
var tick = false
var t = 0
export var tick_dur = 0.2


func _ready():
	visible = false


func start(rng_seed):
	var file = File.new()
	file.open("res://lines", File.READ)
	for i in range(100):
		lines.append(file.get_line())
	file.close()
	var rng = RandomNumberGenerator.new()
	#rng.randomize()
	rng.seed = rng_seed
	var line = lines[rng.randi_range(0,len(lines)-1)]
	$Label.text = line
	$Label.visible_characters = 0
	linelen = len(line)
	visible = true
	$Timer.start()


func _on_timeout():
	tick = true


func _process(delta):
	if tick:
		t += delta
		if t > tick_dur:
			t -= tick_dur
			if $Label.visible_characters < linelen:
				$Label.visible_characters += 1
