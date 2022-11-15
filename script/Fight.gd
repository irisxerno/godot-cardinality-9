extends Node2D


signal done

var stats
var tile
var armory
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
	var take = stats.get_attack()
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

	var cc = $Attack.cards()
	cc.append_array(armory.list())

	var ec = $EnemyAttack.cards()
	ec.append_array($ArmoryController.list())

	$Tally.start_count(cc, ec)


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

	$Attack/LevelBar.count(0)

	if $Mainhand.count()+$Offhand.count() == 0:
		emit_signal("done", false)
	elif $EnemyController.count() == 0:
		emit_signal("done", true)
	else:
		set_input(true)
		var take = stats.get_mainhand() - $Mainhand.count()
		c = []
		for i in range(min(take, $Offhand.count())):
			c.append($Offhand.cards.pop_front())
		$Mainhand.add_cards(c)

func clear():
	for inst in get_children():
		if inst.has_method("return_all"):
			inst.return_all()
	tile = null
