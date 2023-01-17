extends Control


var warntext = "lowest yet!"

var t = 0
var tick = false
export var tick_dur = 0.1


func _process(delta):
	if tick:
		t += delta
		if t > tick_dur:
			t -= tick_dur
			for c in get_children():
				if c.visible_characters < len(c.text):
					c.visible_characters += 1
					break


func update_results(results, lw):
	$Score.text = str(results["score"])+"."
	$Time.text = str(int(results["time"]/60)) + " m"
	$Progress.text = str(results["progress"])+"/90"

	if true:
		if lw[0]:
			$ScoreWarn.text = warntext
		if lw[1]:
			$TimeWarn.text = warntext
		if lw[2]:
			$ProgressWarn.text = warntext


func show():
	for c in get_children():
		c.visible_characters = 0
	visible = true
	tick = true
