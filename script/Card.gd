extends Area2D

export var value = 0
export var suit = 0
export var face_up = false

const value_visual_10 = ["x","J","Q","K"]
const suit_visual = ["Ν","β","δ","λ","φ","Ξ","Γ","Σ","Ψ","Ω","Μ"]

func _ready():
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

func move_to(position):
	if self.position == position:
		return
	var tween = get_node("Tween")
	tween.interpolate_property(self, "position", self.position, position, 0.5, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()

func flip():
	face_up = !face_up
	update_face()
