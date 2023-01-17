extends Node


signal return_cards
signal update
signal card_data
signal reset
signal update_lowest
signal update_results


var savable = false

var stats
var armory
var world
var generator
var color

var saves = []
var lowest = {}

var magic = 1012867408

var gametime = 0
var idletime = 0


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
		save_f.close()
	emit_signal("update", saves)
	if len(lowest) > 0:
		emit_signal("update_lowest", lowest)

	if len(saves) > 0:
		load_next(-1)
	else:
		load_next(false)


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
	while len(saves) > 5:
		saves.pop_front()

	var save_game = File.new()
	save_game.open_compressed("user://save", File.WRITE, File.COMPRESSION_GZIP)
	var savefile = {}
	savefile["saves"] = saves
	savefile["magic"] = magic
	savefile["lowest"] = lowest
	save_game.store_line(to_json(savefile))


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
	save_file()
	emit_signal("update", saves)


func load_save(i):
	savable = false
	emit_signal("reset", i)


func load_next(i):
	if typeof(i) < 2:
		generator.new_game()
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
