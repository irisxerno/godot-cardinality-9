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


func show_repairs(reward, hand_regen, leftover, extra_regen, gained_xp):
	t = 0
	visible = true
	var sb = PoolStringArray()
	var sec_visible = 1
	sb.append(str(reward))
	if hand_regen > 0:
		sb.append("-")
		sb.append(str(hand_regen))
		sec_visible += 1
	if leftover+extra_regen > 0 and abs(leftover-extra_regen) > 0:
		var sbm = PoolStringArray()
		sbm.append("(")
		if leftover > 0:
			sbm.append("+")
			sbm.append(str(leftover))
			sec_visible += 1
		if extra_regen > 0:
			sbm.append("-")
			sbm.append(str(extra_regen))
			sec_visible += 1
		sbm.append(")")
		sb.append(sbm.join(""))
	if len(sb) > 1:
		sb.append("=")
		sb.append(gained_xp)
		sec_visible += 1
	sb.append("xp")
	$Label.text = sb.join(" ")
	$Label.visible_characters = 0
	$Timer.wait_time = sec_visible


func _on_timeout():
	visible = false
