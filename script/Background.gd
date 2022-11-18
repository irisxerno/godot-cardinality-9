extends ColorRect


export var duration = 1.0


var colors = {
	none = Color("1f1f1f"),
	build = Color("#2a2a2a"),
	fight = Color("#332929"),
	death = Color("#540016"),
	growth = Color("#2b332b"),
	flash = Color(1,1,1,0.5),
	off = Color(0,0,0,0)
}


func color(c):
	if colors.has(c):
		return colors[c]
	else:
		return c


func to_color(cname, d=duration):
	$Tween.interpolate_property(self, "color", self.color, color(cname), d, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()


func set_color(cname):
	self.color = color(cname)
