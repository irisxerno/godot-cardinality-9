extends Node2D


signal to_front

export var value = 0
export var suit = 0
export var face_up = false

const value_visual_10 = ["x","J","Q","K"]
const suit_visual = ["Ν","β","δ","λ","φ","Ξ","Γ","Σ","Ψ","Ω"]

var dest_position = position
var dest_a = 1

var death = false
var kill = false

var test = false
export var armory = false
export var diamond = false

var test_notween = false


func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	if test:
		value = rng.randi_range(1,13)
		suit = rng.randi_range(1,9)
	update_face()


func update_face():
	if self.value >= 10 and self.value <= 13:
		$Face/Value.text = value_visual_10[self.value-10]
	elif self.value == 1:
		$Face/Value.text = "A"
	else:
		$Face/Value.text = str(value)
	$Face/Suit.text = suit_visual[self.suit]

	var h = 1.0/9.0*(suit-1) + 0.5/9.0
	$Face.modulate = Color.from_hsv(h, 0.6, 1)

	if face_up:
		$Border.visible = false
		$Face.visible = true
		$Display.modulate = Color.from_hsv(0, 0.2, 0.2, 0.75)
	else:
		$Border.visible = true
		$Face.visible = false
		$Display.modulate = Color8(22, 18, 18)


func move_to(new_position):
	update_face()
	emit_signal("to_front", self)
	if position == new_position or dest_position == new_position:
		return
	dest_position = new_position
	if test_notween:
		self.position = dest_position
		return
	$Tween.interpolate_property(self, "position", position, dest_position, 0.5, Tween.TRANS_QUAD)
	$Tween.start()


func to_alpha(a):
	if test_notween and kill:
		queue_free()
	$AlphaTween.interpolate_property(self, "modulate", self.modulate, Color(1, 1, 1, a), 1, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$AlphaTween.start()


func kill(k=true):
	kill = k
	to_alpha(0)


func b_value():
	if self.value == 1:
		return 15
	return self.value


func flip():
	face_up = !face_up
	update_face()


func _on_AlphaTween_completed(object, key):
	if kill:
		queue_free()
