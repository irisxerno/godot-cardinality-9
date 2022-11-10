extends ColorRect


var colors = {
	none = Color("1a1a1a"),
	build = Color("#2a2a2a"),
	fight = Color("#332929"),
	death = Color("#540016"),
	growth = Color("#2b332b")
}


func _ready():
	self.color = colors["none"]


func to_color(cname):
	$Tween.interpolate_property(self, "color", self.color, colors[cname], 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()


func set_color(cname):
	self.color = colors[cname]
