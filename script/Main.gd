extends Node


var state = "none"


func _ready():
	$Background.set_color("none")

	var stats = $Tabs/StatsView/Stats
	var armory = $UserArmory
	var diamond = $UserDiamond
	var world = $Tabs/WorldView/World
	$Builder.stats = stats
	$Builder.armory = armory
	$Builder.diamond = diamond
	$Savior.stats = stats
	$Savior.armory = armory
	$Savior.diamond = diamond
	$Savior.world = world
	$Savior.generator = $WorldGeneration
	$Savior.tutorial = $Tutorializer
	$Savior.idle_filter = $IdleFilter
	$Tutorializer.stats = stats
	$Fight.stats = stats
	$Fight.armory = armory
	$Fight.diamond = diamond

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
	$UserDiamond.visible = false
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
	$UserDiamond.visible = true
	#$Tabs.update_all("close")
	$Tutorializer.show_tabs()
	$Background.to_color("build")
	state = "build"


func _on_Fight_done(win):
	$Tabs/Cancel.update_state("hide")
	var s = 0

	if win:
		$Savior.savable = true
		$Builder.clear()

		if $Fight.tile.col == 4:
			$Foreground.set_color("flash")
			$Foreground.to_color("off")
			if $Savior.ending_on_world($Tabs/WorldView/World.num):
				s = 1
			else:
				s = 2

		var reward_c = $Fight.tile.reward
		var reward = len(reward_c) # max xp gain
		var leftover = $Fight/Extra.count() # leftovers added as xp
		var extra = $Tabs/StatsView/Stats/Extra.level # how much extra wants on top
		# regen: how much your hand wants
		var regen = $Tabs/StatsView/Stats/Mainhand.level + $Tabs/StatsView/Stats/Offhand.level - $Fight/Mainhand.count() - $Fight/Offhand.count()
		var maxc = regen + extra # how much your deal wants
		var r = []
		if maxc > 0:
			r = reward_c.slice(0, maxc-1)
		var total_regen = len(r) # how much xp was used as regen
		var extra_regen = max(0,total_regen - regen) # how much xp was used in extra
		var hand_regen = max(0,total_regen - extra_regen) # how much xp was used as hand
		var gained_xp = reward-total_regen+leftover

		$Repairs.show_repairs(reward, hand_regen, leftover, extra_regen, gained_xp)
		$Tabs/StatsView/Stats.reset_ticks()
		$Tabs/StatsView/Stats.add_xp(gained_xp)

		$Tabs/WorldView/World.defeat($Fight.tile)
		$Tutorializer.on_win($Fight.tile.col, $Tabs/WorldView/World.num)

		if s == 1:
				print("victory!")
				$Fight.clear(true)
				$Cards.kill(true)
				$Armories.kill(true)
				$Builder.visible = false
				$Fight.visible = false
				$Background.to_color(Color.white, 10)
				$Savior.archive()
				# DEBUG: needs ending shit !!!
				$Tabs/SaveView.force_show()
				return
		elif s == 2:
			$WorldGeneration.return_world(true)

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
	$UserDiamond.position = Vector2(w.x - 260, 570)
	sort_them()


func _on_World_ccount(cc):
	$Tabs/WorldView.open_distance = 100 * cc + 50


func reset():
	$Background.to_color("none")
	$Tabs.update_all("hide", true)
	$Builder.visible = true
	$Fight.visible = false
	
	$Builder.clear(true)
	$UserArmory.new()
	$UserDiamond.new()
	$Cards.kill()
	$Savior.load_next()


func sort_them():
	$UserArmory.update_armories()
	$UserDiamond.update_armories()

