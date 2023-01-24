extends Control


var t = 0
export var tick_dur = 0.05


func _ready():
	visible = false


func _process(delta):
	if $Label.visible_characters < len($Label.text):
		t += delta
		if t > tick_dur:
			t -= tick_dur
			$Label.visible_characters += 1
			if $Label.visible_characters >= len($Label.text):
				$Timer.start()


func show_repairs(xp, rp):
	t = 0
	visible = true
	if rp > 0:
		$Label.text = "{0} - {1} = {2} xp".format([xp, rp, xp - rp])
	else:
		$Label.text = "{0} xp".format([xp])
	$Label.visible_characters = 0


func _on_timeout():
	visible = false
