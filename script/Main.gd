extends Node

signal start_fight

var state = "none"

func _ready():
	$Tabs.update_all("hide")
	$Builder.visible = true
	$Fight.visible = false


func _on_select_tile(tile):
	if state != "build":
		return

	# check if its even possible to fight

	$Tabs.update_all("hide")
	$Builder.visible = false
	$Fight.visible = true
	state = "fight"
	$Fight.input = false
	$Background.set_color("fight")
	$Fight.attack = $Tabs/StatsView/Stats/Attack.level
	$Fight/Mainhand.add_cards($Builder/Mainhand.cards())
	$Fight/Extra.add_cards($Builder/Deal.cards())
	$Fight/Offhand.add_cards($Builder/Offhand.cards())
	$Fight/Dealer.deal_from_data(tile.cards)


func _on_GameStartDealer_done():
	$Tabs.update_all("close")
	$Background.set_color("build")
	state = "build"
