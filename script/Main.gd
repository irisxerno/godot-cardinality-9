extends Node


var state = "none"


func _ready():
	$Background.set_color("none")

	var stats = $Tabs/StatsView/Stats
	var armory = $UserArmory
	var world = $Tabs/WorldView/World
	$Builder.stats = stats
	$Builder.armory = armory
	$Savior.stats = stats
	$Savior.armory = armory
	$Savior.world = world
	$Savior.generator = $WorldGeneration
	$Savior.tutorial = $Tutorializer
	$Tutorializer.stats = stats
	$Fight.stats = stats
	$Fight.armory = armory

	$Tabs.update_all("hide", false)
	$Builder.visible = true
	$Fight.visible = false
	
	$Savior.start()


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

	$Fight.tile = tile
	$Fight/Mainhand.add_cards($Builder/Mainhand.cards())
	$Fight/Extra.add_cards($Builder/Deal.cards())
	$Fight/Offhand.add_cards($Builder/Offhand.cards())
	$Fight/Dealer.deal_from_data(tile.cards)
	$Fight/Dealer.start()
	$Fight/ArmoryController.deal_from_data(tile.armories)


func to_build():
	$UserArmory.visible = true
	#$Tabs.update_all("close")
	$Tutorializer.show_tabs()
	$Background.to_color("build")
	state = "build"


func _on_Fight_done(win):
	$Tabs/Cancel.update_state("hide")
	var ending = false

	if win:
		$Savior.savable = true
		$Builder.clear()

		if $Fight.tile.col == 4:
			$WorldGeneration.return_new_world($Tabs/WorldView/World.num+1)
			$Foreground.set_color("flash")
			$Foreground.to_color("off")
			if $Tabs/WorldView/World.num > 5:
				ending = true


		var reward = $Fight.tile.reward
		var maxc = $Tabs/StatsView/Stats/Mainhand.level + $Tabs/StatsView/Stats/Offhand.level + $Tabs/StatsView/Stats/Extra.level - $Fight/Mainhand.count() - $Fight/Offhand.count()
		var r = []
		if maxc > 0:
			r = reward.slice(0, maxc-1)

		$Tabs/StatsView/Stats.reset_ticks()
		$Tabs/StatsView/Stats.add_xp($Fight/Extra.count()+len(reward)-len(r))

		$Tabs/WorldView/World.defeat($Fight.tile)

		if ending:
				print("victory!")
				$Fight.clear(true)
				$Cards.kill(true)
				$Armories.kill(true)
				$Builder.visible = false
				$Fight.visible = false
				$Background.to_color(Color.white, 10)
				$Ending.start($WorldGeneration.seed_value)
				$Tutorializer.on_ending()
				$Savior.archive()
				return

		$Builder/Dealer.add_cards($Fight/Mainhand.cards())
		$Builder/Dealer.add_cards($Fight/Offhand.cards())
		$Builder/Dealer.deal_from_data(r)
		$Builder/Dealer.start()

		$Background.set_color("growth")
		$Background.to_color("none")
	else:
		$Background.set_color("death")
		$Background.to_color("build")
		to_build()

	state = "build"
	$Builder.visible = true
	$Fight.visible = false

	$Fight.clear(true)

	$Builder.update()

	$Cards.kill()

func _on_Tabs_resized():
	var w = $Tabs.rect_size
	$Fight/Extra.position = Vector2(w.x+100,w.y/2)
	$UserArmory.position = Vector2(w.x - 260, 640)


func _on_World_ccount(cc):
	$Tabs/WorldView.open_distance = 100 * cc + 50


func reset(i):
	$Tabs.update_all("hide", true)
	$Builder.visible = true
	$Fight.visible = false
	
	$Builder.clear(true)
	$UserArmory.new()
	$Cards.kill()
	$Savior.load_next(i)
