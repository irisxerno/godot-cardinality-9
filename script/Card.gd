extends Area2D

export var value = 0
export var suit = 0

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
	
	var h = 1.0/9.0*(suit-1)
	$Face.modulate = Color.from_hsv(h, 0.5, 0.9)
