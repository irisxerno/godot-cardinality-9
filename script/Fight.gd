extends Node2D

export var attack = 5
var input = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Mainhand_request_return_cards(inst):
	if not input:
		return

	var mainhand_curr = $Mainhand.count
	var attack_curr = $Attack.count
	var take = attack
	var c = inst.cards.slice(max(len(inst.cards)-take,0), len(inst.cards)-1)
	inst.remove_cards(c)
	$Attack.add_cards(c)
	$Mainhand.toggle()

	inst = $EnemyController
	var enemy_curr = inst.count
	attack_curr = $EnemyAttack.count
	take = $Attack.count
	c = inst.cards.slice(max(inst.count-take,0), inst.count-1)
	inst.remove_cards(c)
	$EnemyAttack.add_cards(c)
	$EnemyController.toggle()

	input = false
	
	$Tally.start_count($Attack.cards(), $EnemyAttack.cards())


func _on_Dealer_done():
	input = true
