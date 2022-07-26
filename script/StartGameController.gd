extends Node2D

signal add_card
signal return_cards

var cards = []
var anim_count = 0

export var deal_count = 10
export var deal_suits = 4
export var step = Vector2(1,1)
export var quick = false

func _ready():
	if quick:
		$DealAnimTimer.wait_time /= 2
		$DispAnimTimer.wait_time /= 2

	var scene = load("res://scene/Card.tscn")
	randomize()
	for i in range(deal_count):
		var inst = scene.instance()
		inst.position = position
		inst.value = randi() % 12 + 2
		inst.suit = randi() % deal_suits + 1
		inst.face_up = true
		cards.append(inst)
		emit_signal("add_card", inst)
	$DealAnimTimer.start()

#func _process(delta):
#	pass

func _on_DealAnimTimer_timeout():
	cards[anim_count].move_to(position+$MoveTo.position+step*anim_count)
	anim_count += 1
	if anim_count >= len(cards):
		$DealAnimTimer.stop()
		$DispAnimTimer.start()

func _on_DispAnimTimer_timeout():
	emit_signal("return_cards", cards)
	queue_free()
