extends Node


var state = "none"


func _ready():
	$WorldGeneration.new_game()
	$Background.set_color("none")
	$Builder.stats = $Tabs/StatsView/Stats
	$Builder.armory = $UserArmory
	$Fight.armory = $UserArmory
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
	$UserArmory.visible = false
	$Background.to_color("fight")

	$Fight.stats = $Tabs/StatsView/Stats
	$Fight.tile = tile
	$Fight/Mainhand.add_cards($Builder/Mainhand.cards())
	$Fight/Extra.add_cards($Builder/Deal.cards())
	$Fight/Offhand.add_cards($Builder/Offhand.cards())
	$Fight/Dealer.deal_from_data(tile.cards)
	$Fight/Dealer.start()
	$Fight/ArmoryController.deal_from_data(tile.armories)


func to_build():
	$UserArmory.visible = true
	$Tabs.update_all("close")
	$Tabs/StatsView.update_state("open")
	$Background.to_color("build")
	state = "build"


func _on_Fight_done(win):
	# TODO: losing animation

	$Cards.mark_death()

	if win:
		$Builder.clear()

		var reward = $Fight.tile.reward
		var maxc = $Tabs/StatsView/Stats/Mainhand.level + $Tabs/StatsView/Stats/Offhand.level + $Tabs/StatsView/Stats/Extra.level - $Fight/Mainhand.count() - $Fight/Offhand.count()
		var r = []
		if maxc > 0:
			r = reward.slice(0, maxc-1)

		$Builder/Dealer.add_cards($Fight/Mainhand.cards())
		$Builder/Dealer.add_cards($Fight/Offhand.cards())
		$Builder/Dealer.deal_from_data(r)
		$Builder/Dealer.start()

		$Tabs/StatsView/Stats.reset_ticks()
		$Tabs/StatsView/Stats.add_xp($Fight/Extra.count()+len(reward)-len(r))

		$UserArmory.kill_cards()

		$Tabs/WorldView/World.defeat($Fight.tile)
		$Background.set_color("growth")
		$Background.to_color("none")

		if $Fight.tile.col == 4:
			$WorldGeneration.return_new_world($Tabs/WorldView/World.num+1)
			$Foreground.set_color("flash")
			$Foreground.to_color("off")
	else:
		$Background.set_color("death")
		$Background.to_color("build")
		to_build()

	state = "build"
	$Builder.visible = true
	$Fight.visible = false

	$Builder.update()
	
	$Fight.clear()
	
	$Cards.kill()


func _on_Tabs_resized():
	$Fight/Extra.position = Vector2(OS.window_size.x+45,OS.window_size.y/2)
	$UserArmory.position = Vector2(OS.window_size.x - 260, 640)


func _on_World_ccount(cc):
	$Tabs/WorldView.open_distance = 100 * cc + 50
