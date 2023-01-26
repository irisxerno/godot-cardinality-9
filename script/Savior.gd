extends Node


signal return_cards
signal update
signal card_data
signal reset
signal update_lowest
signal update_results


var savable = false
var n_i
var n_mode

var stats
var armory
var world
var generator
var color
var tutorial

var saves = []
var lowest = {}

var magic = 135606722

var gametime = 0
var idletime = 0

var savefile_json


func _process(delta):
	idletime += delta
	if idletime < 60:
		gametime += delta


func _input(event):
	idletime = 0


func archive():
	var sc = stats.score - stats.xp
	var lw = [false, false, false]
	if len(lowest) == 0:
		lowest["score"] = sc
		lowest["progress"] = stats.progress
		lowest["time"] = gametime
		lw = [true, true, true]
	else:
		if sc < lowest["score"]:
			lowest["score"] = sc
			lw[0] = true
		if stats.progress < lowest["progress"]:
			lowest["progress"] = stats.progress
			lw[1] = true
		if gametime < lowest["time"]:
			lowest["time"] = gametime
			lw[2] = true

	saves = []
	save_file()

	var results = {}
	results["score"] = sc
	results["progress"] = stats.progress
	results["time"] = gametime

	emit_signal("update_results", results, lw)


func start():
	var save_f = File.new()
	var dir = Directory.new()
	if dir.file_exists("user://save"):
		save_f.open_compressed("user://save", File.READ, File.COMPRESSION_GZIP)
		var savefile = parse_json(save_f.get_line())
		if typeof(savefile) == 18 and "magic" in savefile:
			var svmg = savefile["magic"]
			if magic == svmg:
				saves = savefile["saves"]
				lowest = savefile["lowest"]
				tutorial.set_tutorial(savefile["tutorial_progress"], savefile["stats_progress"])
		save_f.close()
	emit_signal("update", saves)
	if len(lowest) > 0:
		emit_signal("update_lowest", lowest)

	if len(saves) > 0:
		load_save(-1)
	else:
		load_save(false)


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
	savefile_json = null
	if tutorial.tutorial:
		print("refusing to save tutorial")
		return

	var savefile = {}
	savefile["saves"] = saves
	savefile["magic"] = magic
	savefile["lowest"] = lowest
	savefile["tutorial_progress"] = tutorial.tutorial_progress
	savefile["stats_progress"] = tutorial.stats_progress
	savefile_json = to_json(savefile)
	if tutorial.inhibit_for_stats:
		print("save inhibited")
	else:
		save_to_file()


func save_to_file():
	if not savefile_json:
		print("no stored json")
		return
	var save_game = File.new()
	save_game.open_compressed("user://save", File.WRITE, File.COMPRESSION_GZIP)
	save_game.store_line(savefile_json)
	savefile_json = null
	print("saved")


func save(cards):
	var card_data = cards_to_data(cards)
	var armory_data = armory.to_data()
	var stat_data = stats.to_data()
	var world_data = world.to_data()

	var data = {
		"color": color,
		"cards": card_data,
		"armories": armory_data,
		"stats": stat_data,
		"world": world_data,
		"world_num": world.num,
		"rng_seed": generator.seed_value,
		"rng_state": generator.rng.state,
		"time": gametime
	}
	saves.append(data)
	while len(saves) > 5:
		saves.pop_front()

	save_file()
	emit_signal("update", saves)


func load_save(i, mode="game"):
	savable = false
	n_i = i
	n_mode = mode
	emit_signal("reset")


func load_next():
	if n_i == null:
		return
	var i = n_i
	n_i = null
	var mode = n_mode
	n_mode = null
	if typeof(i) < 2:
		generator.new_game(mode)
		return
	var data = saves[i]

	emit_signal("card_data", data["cards"])
	armory.from_data(data["armories"])
	stats.from_data(data["stats"])
	world.from_data(data["world"], data["world_num"])

	generator.seed_value = data["rng_seed"]
	generator.rng.seed = generator.seed_value
	generator.rng.state = data["rng_state"]

	gametime = data["time"]

	color = data["color"]


func color(c):
	color = c


func newgame():
	gametime = 0
	load_save(false)


func newgame_tutorial():
	gametime = 0
	tutorial.set_tutorial(0, 0)
	load_save(false)


func newgame_debug():
	gametime = 0
	tutorial.set_tutorial(4,5)
	load_save(false, "debug")
