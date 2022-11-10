extends Area2D


signal to_front

export var value = 0
export var suit = 0
export var face_up = false

const value_visual_10 = ["x","J","Q","K"]
const suit_visual = ["Ν","β","δ","λ","φ","Ξ","Γ","Σ","Ψ","Ω","Μ"]

var dest_position = position
var dest_a = 1

var death = false

export var test = false


func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	if test:
		value = rng.randi_range(2,13)
		suit = rng.randi_range(1,9)
	update_face()


func update_face():
	if self.value >= 10 and self.value <= 13:
		$Face/Value.text = value_visual_10[self.value-10]
	else:
		$Face/Value.text = str(value)
	$Face/Suit.text = suit_visual[self.suit]

	var h = 1.0/9.0*(suit-1) + 0.5/9.0
	$Face.modulate = Color.from_hsv(h, 0.6, 0.9)

	if face_up:
		$Back.visible = false
		$Face.visible = true
	else:
		$Back.visible = true
		$Face.visible = false


func move_to(new_position):
	update_face()
	emit_signal("to_front", self)
	if position == new_position or dest_position == new_position:
		return
	dest_position = new_position
	$Tween.interpolate_property(self, "position", position, dest_position, 0.5, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()


func kill():
	$AlphaTween.interpolate_property(self, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 2, Tween.TRANS_QUAD)
	$AlphaTween.start()


func flip():
	face_up = !face_up
	update_face()
	


func _on_AlphaTween_completed(object, key):
	queue_free()
