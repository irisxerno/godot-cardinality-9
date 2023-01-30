extends Node


signal return_cards
signal card_data
signal reset
signal update_gamemode
signal update_saves
signal update_scoreboard
signal update_results



var savable = false

var n_i = false
var n_list = "latest"
var gamemode = "tutorial"
var gamemode_sequence = ["tutorial", "normal", "hard", "hardcore", "debug"]

var stats
var armory
var diamond
var world
var generator
var color
var tutorial

var gametime = 0
var idletime = 0

var version = 0

var save_data
var savefile_json

var file_path = "user://save_debug"
var file_compression = null


func color(c):
	color = c


func skel_gamemode(m="tutorial"):
	var skel = {
		"latest": [],
		"world": []
	}
	if m == "tutorial":
		skel["progress"] = {
			"tutorial": 0,
			"stats": 0
		}
	if m == "normal" or m == "hard" or m == "hardcore":
		skel["scoreboard"] = {
			"low": {
				"usedxp": [],
				"time": [],
				"progress": []
			},
			"high": {
				"usedxp": [],
				"score": [],
				"progress": []
			},
			"latest": []
		}
	if m == "hardcore":
		skel["bones"] = {
			"high": {
				"usedxp": [],
				"score": [],
				"progress": []
			},
			"latest": []
		}
	return skel


# move these to world
var gm_ending_world = {
	"tutorial": 3,
	"normal": 4,
	"hard": 5,
	"hardcore": 5,
	"debug": 10
}


func ending_on_world(n):
	return n >= gm_ending_world[gamemode]


func _process(delta):
	idletime += delta
	if idletime < 60:
		gametime += delta


func _input(event):
	idletime = 0


func archive():
	var gm_i = gamemode_sequence.find()
	if gm_i+1 < len(gamemode_sequence):
		var ng = gamemode_sequence[gm_i+1]
		if not ng in save_data:
			save_data[ng] = skel_gamemode(ng)
	# save_data[gamemode]["latest"] = []
	# save_data[gamemode]["world"] = []
#	var sc = stats.score - stats.xp
#	var lw = [false, false, false]
#	if len(lowest) == 0:
#		lowest["score"] = sc
#		lowest["progress"] = stats.progress
#		lowest["time"] = gametime
#		lw = [true, true, true]
#	else:
#		if sc < lowest["score"]:
#			lowest["score"] = sc
#			lw[0] = true
#		if stats.progress < lowest["progress"]:
#			lowest["progress"] = stats.progress
#			lw[1] = true
#		if gametime < lowest["time"]:
#			lowest["time"] = gametime
#			lw[2] = true
#
#	saves = []
	save_file()
#
#	var results = {}
#	results["score"] = sc
#	results["progress"] = stats.progress
#	results["time"] = gametime
#
#	emit_signal("update_results", results, lw)


func start():
	savable = false
	n_i = -1
	n_list = "latest"
	gamemode = "tutorial"
	save_data = {
		"version": version,
		"last_gamemode": "tutorial",
	}
	for gm in gamemode_sequence:
		save_data[gm] = skel_gamemode(gm)
	tutorial.set_progress(save_data[gamemode]["progress"])
	var save_f = File.new()
	var dir = Directory.new()
	if dir.file_exists(file_path):
		if file_compression:
			save_f.open_compressed(file_path, File.READ, file_compression)
		else:
			save_f.open(file_path, File.READ)
		var savefile = parse_json(save_f.get_line())
		if typeof(savefile) == 18 and "version" in savefile:
			var sv_ver = savefile["version"]
			if version == sv_ver:
				save_data = savefile
				set_gamemode(save_data["last_gamemode"])
		save_f.close()
	load_save()


func cards_to_data(c):
	var data = []
	for inst in c:
		data.append({
			"value": inst.value,
			"suit": inst.suit
		})
	return data


func get_cards(cards):
	if savable:
		save(cards)
	emit_signal("return_cards", cards)


func save_file():
	save_data[gamemode]["progress"] = tutorial.to_data()
	savefile_json = to_json(save_data)
	if tutorial.inhibit_for_stats:
		print("save inhibited")
	else:
		save_to_file()


func save_to_file():
	if tutorial.tutorial:
		print("refusing to save tutorial")
		return
	if not savefile_json:
		print("no stored json")
		return
	var save_game = File.new()
	if file_compression:
		save_game.open_compressed(file_path, File.WRITE, file_compression)
	else:
		save_game.open(file_path, File.WRITE)
	save_game.store_line(savefile_json)
	print("saved")


func save(cards):
	var card_data = cards_to_data(cards)
	var armory_data = armory.to_data()
	var diamond_data = diamond.to_data()
	var stat_data = stats.to_data()
	var world_data = world.to_data()

	var data = {
		"color": color,
		"cards": card_data,
		"armories": armory_data,
		"diamond": diamond_data,
		"stats": stat_data,
		"world": world_data,
		"world_num": world.num,
		"rng_seed": generator.seed_value,
		"rng_state": generator.rng.state,
		"time": gametime
	}
	
	if gamemode == "hardcore":
		save_data["hardcore"]["latest"] = []

	var svl = save_data[gamemode]["latest"]
	svl.append(data)
	while len(svl) > 5:
		svl.pop_front()
	save_data[gamemode]["latest"] = svl
	
	if gamemode != "hardcore":
		svl = save_data[gamemode]["world"]
		var si = 0
		var wa = true
		while si < len(svl):
			if svl[si]["world_num"] == world.num:
				wa = false
				break
			si += 1
		if wa:
			svl.append(data)
		else:
			svl[si] = data
		while len(svl) > 5:
			svl.pop_front()
		save_data[gamemode]["world"] = svl

	save_data["last_gamemode"] = gamemode
	save_file()


func _on_request_saves(m_gm, m_list):
	emit_signal("update_saves", save_data[m_gm][m_list])


func _on_Saves_load_save(m_list, index, m_gm):
	n_list = m_list
	n_i = index
	set_gamemode(m_gm)
	load_save()
	if typeof(index) < 2:
		if gamemode == "tutorial":
			tutorial.set_progress({
				"tutorial":0,
				"stats":0
			})
			save_data["tutorial"]["latest"] = []
			save_data["tutorial"]["world"] = []
		if gamemode == "debug":
			stats.unlocked = 6
			stats.update()


func load_save():
	savable = false
	emit_signal("reset")


func load_next():
	if typeof(n_i) < 2 or len(save_data[gamemode][n_list]) < 1: # null or bool
		generator.new_game()
		return
	var data = save_data[gamemode][n_list][n_i]

	emit_signal("card_data", data["cards"])
	armory.from_data(data["armories"])
	diamond.from_data(data["diamond"])
	stats.from_data(data["stats"])
	world.from_data(data["world"], data["world_num"])

	generator.seed_value = data["rng_seed"]
	generator.rng.seed = generator.seed_value
	generator.rng.state = data["rng_state"]

	gametime = data["time"]

	color = data["color"]


func set_gamemode(new_gm):
	# here: nourgency, nodiamond, noscoreboard, hardcore
	# tutorial, stats, saves, scoreboard
	gamemode = new_gm
	if "progress" in save_data[gamemode]:
		tutorial.set_progress(save_data[gamemode]["progress"])
	else:
		tutorial.set_progress(false)
	generator.mode = gamemode
	emit_signal("update_gamemode", gamemode)
