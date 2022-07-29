extends Node2D

signal add_card
signal return_cards

var cards = []
var anim_count = 0

export var deal_count = 10
export var deal_suits = 4
export var step = Vector2(1,1)
export var quick = false

func deal_from_data(card_data):
	var scene = preload("res://scene/Card.tscn")
	for d in card_data:
		var inst = scene.instance()
		inst.value = d["value"]
		inst.suit = d["suit"]
		inst.position = self.position
		inst.face_up = true
		cards.append(inst)
		emit_signal("add_card", inst)
	$DealAnimTimer.start()
	
func _on_DealAnimTimer_timeout():
	cards[anim_count].move_to(position+$MoveTo.position+step*anim_count)
	anim_count += 1
	if anim_count >= len(cards):
		$DealAnimTimer.stop()
		$DispAnimTimer.start()

func _on_DispAnimTimer_timeout():
	emit_signal("return_cards", cards)
	queue_free()
