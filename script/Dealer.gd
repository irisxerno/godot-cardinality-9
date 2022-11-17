extends Node2D


signal add_card
signal return_cards
signal done

var cards = []
var anim_count = 0

export var step = Vector2(1,1)

export var face_up = true


func add_cards(ns):
	for inst in ns:
		inst.death = false
		inst.face_up = true
		inst.update_face()
		cards.append(inst)


func deal_data_now(card_data):
	deal_from_data(card_data)
	start()


func deal_from_data(card_data):
	if len(card_data) == 0:
		return
	var scene = preload("res://scene/Card.tscn")
	for d in card_data:
		var inst = scene.instance()
		inst.value = d["value"]
		inst.suit = int(d["suit"])
		inst.position = self.position
		inst.face_up = face_up
		cards.append(inst)
		emit_signal("add_card", inst)


func start():
	$DealAnimTimer.start()


func update():
	for inst in cards:
		inst.death = false


func _on_DealAnimTimer_timeout():
	cards[anim_count].move_to(position+$MoveTo.position+step*anim_count)
	anim_count += 1
	if anim_count >= len(cards):
		$DealAnimTimer.stop()
		$DispAnimTimer.start()


func _on_DispAnimTimer_timeout():
	emit_signal("return_cards", cards)
	emit_signal("done")
	cards = []
	anim_count = 0
