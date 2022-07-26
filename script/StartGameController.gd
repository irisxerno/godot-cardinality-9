extends Position2D

signal add_child
signal return_cards

var cards = []
var anim_count = 0

export var deal_count = 10
export var step = Vector2(1,1)

func _ready():
	var scene = load("res://scene/Card.tscn")
	randomize()
	for i in range(deal_count):
		var inst = scene.instance()
		inst.position = position
		inst.value = randi() % 12 + 2
		inst.suit = randi() % 4 + 1
		inst.face_up = true
		cards.append(inst)
		emit_signal("add_child", inst)
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
	emit_signal("return_cards", "DealController", cards)
	queue_free()
