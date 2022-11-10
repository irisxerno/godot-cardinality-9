extends Node2D


signal done

var attack = 5
var tile
var input = true


func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		$EnemyController.toggle()


func set_input(i):
	if input == i:
		return
	input = !input
	$Mainhand.toggle()
	$EnemyController.toggle()


func _on_Mainhand_request_return_cards(inst):
	if not input:
		return

	set_input(false)

	var mainhand_curr = $Mainhand.count
	var attack_curr = $Attack.count
	var take = attack
	var c = inst.cards.slice(max(len(inst.cards)-take,0), len(inst.cards)-1)
	inst.remove_cards(c)
	$Attack.add_cards(c)

	inst = $EnemyController
	var enemy_curr = inst.count
	attack_curr = $EnemyAttack.count
	take = $Attack.count
	
	c = []
	for i in range(min(take, len(inst.cards))):
		c.append(inst.cards.pop_front())
	
	inst.update()
	$EnemyAttack.add_cards(c)
	
	$Tally.start_count($Attack.cards(), $EnemyAttack.cards())


func _on_Dealer_done():
	set_input(true)
	#pass


func _on_Dealer_return_cards(new_cards):
	$EnemyController.cards.append_array(new_cards)
	set_input(true)


func _on_Tally_done(c):
	var dest = $Trash
	if c >= 0:
		dest = $Mainhand
	dest.add_cards($EnemyAttack.return_all())
	dest = $Trash
	if c <= 0:
		dest = $EnemyController
	dest.add_cards($Attack.return_all())

	# TODO: Attempt to add cards from Offhand

	$Attack/LevelBar.count(0)

	if $Mainhand.count() == 0:
		emit_signal("done", false)
	elif $EnemyController.count() == 0:
		emit_signal("done", true)
	else:
		set_input(true)

func clear():
	for inst in get_children():
		if inst.has_method("return_all"):
			inst.return_all()
	tile = null
