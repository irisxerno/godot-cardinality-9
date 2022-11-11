extends Node

signal start_fight

var state = "none"

func _ready():
	$Builder.stats = $Tabs/StatsView/Stats
	$Tabs.update_all("hide", false)
	$Builder.visible = true
	$Fight.visible = false


func _on_select_tile(tile):
	if state != "build":
		return

	if $Builder/Mainhand.count() == 0:
		$Background.set_color("death")
		$Background.to_color("build")
		return

	state = "fight"
	$Tabs.update_all("hide")
	$Builder.visible = false
	$Fight.visible = true
	$Fight.set_input(false)
	$Background.to_color("fight")

	$Fight.stats = $Tabs/StatsView/Stats
	$Fight.tile = tile
	$Fight/Mainhand.add_cards($Builder/Mainhand.cards())
	$Fight/Extra.add_cards($Builder/Deal.cards())
	$Fight/Offhand.add_cards($Builder/Offhand.cards())
	$Fight/Dealer.deal_from_data(tile.cards)
	$Fight/ArmoryController.deal_from_data(tile.armories)


func _on_GameStartDealer_done():
	$Tabs.update_all("close")
	$Background.to_color("build")
	state = "build"
	call_deferred("update_world_odist")


func update_world_odist():
	var world = $Tabs/WorldView/World
	var view = $Tabs/WorldView
	var cc = world.ccount()
	view.open_distance = world.tile_csize * cc + 40


func _on_Fight_done(win):
	# TODO: losing animation

	if win:
		$Builder.clear()
		$Builder/Mainhand.add_cards($Fight/Mainhand.cards())
		$Builder/Offhand.add_cards($Fight/Offhand.cards())

		var reward = $Fight.tile.reward
		var maxc = $Tabs/StatsView/Stats/Mainhand.level + $Tabs/StatsView/Stats/Offhand.level + $Tabs/StatsView/Stats/Extra.level - $Fight/Mainhand.count() - $Fight/Offhand.count()
		var r = []
		if maxc > 0:
			r = reward.slice(0, maxc-1)
		# TODO: block input while this animation is playing
		$Builder/Dealer.deal_from_data(r)

		# TODO: we need to update the tickers
		$Tabs/StatsView/Stats.return_cost($Fight/Extra.count()+len(reward)-len(r))

		$Tabs/WorldView/World.defeat($Fight.tile)
		$Background.set_color("growth")
	else:
		$Background.set_color("death")

	$Cards.mark_death()
	
	state = "build"
	$Tabs.update_all("close")
	$Builder.visible = true
	$Fight.visible = false
	$Background.to_color("build")
	$Builder.update()
	
	$Fight.clear()
	
	$Cards.kill()
